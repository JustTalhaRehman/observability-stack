# Least-privilege Pod Identity: one IAM role per workload, each role may only access
# its own S3 bucket ARN (no shared "observability" super-policy).
locals {
  components = toset(var.component_names)

  # Trust only this account; optionally bind to a single EKS cluster ARN (recommended).
  pod_identity_trust_condition = merge(
    {
      StringEquals = {
        "aws:SourceAccount" = data.aws_caller_identity.current.account_id
      }
    },
    var.cluster_arn != null ? {
      ArnLike = {
        "aws:SourceArn" = var.cluster_arn
      }
    } : {}
  )
}

data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "component_s3" {
  for_each = local.components

  name_prefix = "${var.name_prefix}-${each.key}-s3-"
  description = "Least-privilege S3 for ${each.key}: list + object RW only on that component bucket"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ListBucket"
        Effect = "Allow"
        Action = ["s3:ListBucket", "s3:GetBucketLocation"]
        Resource = [
          var.bucket_arns[each.key]
        ]
      },
      {
        Sid    = "ObjectRW"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:AbortMultipartUpload",
          "s3:ListBucketMultipartUploads"
        ]
        Resource = ["${var.bucket_arns[each.key]}/*"]
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role" "pod_identity" {
  for_each = local.components

  name_prefix = "${var.name_prefix}-${each.key}-podid-"
  description = "EKS Pod Identity for ${each.key}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Condition = local.pod_identity_trust_condition
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "component_s3" {
  for_each = local.components

  role       = aws_iam_role.pod_identity[each.key].name
  policy_arn = aws_iam_policy.component_s3[each.key].arn
}

resource "aws_eks_pod_identity_association" "this" {
  for_each = local.components

  cluster_name    = var.cluster_name
  namespace       = var.kubernetes_namespace
  service_account = var.service_account_names[each.key]
  role_arn        = aws_iam_role.pod_identity[each.key].arn
}
