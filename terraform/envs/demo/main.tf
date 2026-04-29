module "vpc" {
  source = "../../modules/vpc"

  name = "${var.project_name}-vpc"
  cidr = var.vpc_cidr

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  tags = local.resource_tags
}

module "eks" {
  source = "../../modules/eks"

  cluster_name    = local.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = true

  node_instance_types = var.node_instance_types
  node_min_size       = var.node_min_size
  node_max_size       = var.node_max_size
  node_desired_size   = var.node_desired_size
  node_capacity_type  = var.node_capacity_type

  aws_region = var.aws_region
  tags       = local.resource_tags
}

module "s3_observability" {
  source = "../../modules/s3-observability"

  name_prefix = local.s3_prefix_effective
  suffix      = local.s3_suffix_effective

  tags = local.resource_tags
}

resource "time_sleep" "wait_cluster" {
  depends_on      = [module.eks]
  create_duration = var.cluster_ready_wait
}

module "iam_observability_pod_identity" {
  source = "../../modules/iam-observability-pod-identity"

  name_prefix           = var.project_name
  cluster_name          = module.eks.cluster_name
  cluster_arn           = module.eks.cluster_arn
  kubernetes_namespace  = var.kubernetes_namespace
  bucket_arns           = module.s3_observability.bucket_arns
  service_account_names = var.pod_identity_service_account_names

  tags = local.resource_tags

  depends_on = [module.eks, module.s3_observability, time_sleep.wait_cluster]
}

# Scale-out: extra node groups, cluster-autoscaler/Karpenter, split ingest/query — add in your fork.
