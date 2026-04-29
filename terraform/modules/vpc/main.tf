data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.21"

  name = var.name
  cidr = var.cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, var.az_count)
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = merge(var.tags, {
    "kubernetes.io/role/elb" = "1"
  })

  private_subnet_tags = merge(var.tags, {
    "kubernetes.io/role/internal-elb" = "1"
  })

  tags = var.tags
}
