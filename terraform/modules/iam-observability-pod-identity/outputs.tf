output "role_arns" {
  description = "IAM role ARNs (bound via aws_eks_pod_identity_association — no IRSA annotations required)"
  value       = { for k, r in aws_iam_role.pod_identity : k => r.arn }
}
