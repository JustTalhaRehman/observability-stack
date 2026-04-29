data "aws_eks_cluster" "this" {
  depends_on = [module.eks]
  name       = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  depends_on = [module.eks]
  name       = module.eks.cluster_name
}
