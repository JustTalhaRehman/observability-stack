module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = var.cluster_endpoint_private_access

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  # Portfolio demo uses EKS Pod Identity (addon + associations), not IRSA.
  enable_irsa = false

  cluster_addons = merge(
    {
      eks-pod-identity-agent = {
        most_recent = true
      }
    },
    var.cluster_addons
  )

  eks_managed_node_groups = {
    default = {
      name           = "${var.cluster_name}-ng"
      instance_types = var.node_instance_types
      min_size       = var.node_min_size
      max_size       = var.node_max_size
      desired_size   = var.node_desired_size
      capacity_type  = var.node_capacity_type
    }
  }

  tags = var.tags
}
