variable "aws_region" {
  type        = string
  description = "AWS region for all resources"
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Short name prefix for VPC, cluster, IAM"
  default     = "obs-demo"
}

variable "default_tags" {
  type        = map(string)
  description = "Applied to all supported resources via provider default_tags"
  default = {
    Project   = "observability-stack"
    Phase     = "phase2"
    ManagedBy = "terraform"
  }
}

variable "cluster_version" {
  type    = string
  default = "1.31"
}

variable "cluster_endpoint_public_access" {
  type        = bool
  description = "Set false if API should be private-only (needs VPN/bastion)"
  default     = true
}

variable "cluster_ready_wait" {
  type        = string
  description = "Wait after EKS create before Pod Identity + Helm (addon + nodes)"
  default     = "120s"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "enable_nat_gateway" {
  type        = bool
  description = "NAT is billable; required for private nodes to reach ECR/APIs unless you use VPC endpoints everywhere"
  default     = true
}

variable "single_nat_gateway" {
  type    = bool
  default = true
}

variable "node_instance_types" {
  type        = list(string)
  description = "Single t3.large fits minimal Prometheus+Grafana+Loki+Tempo on one node"
  default     = ["t3.large"]
}

variable "node_min_size" {
  type    = number
  default = 1
}

variable "node_max_size" {
  type    = number
  default = 2
}

variable "node_desired_size" {
  type    = number
  default = 1
}

variable "node_capacity_type" {
  type    = string
  default = "ON_DEMAND"
}

variable "s3_name_prefix" {
  type        = string
  description = "Globally unique S3 bucket prefix; default uses project_name when null"
  default     = null
}

variable "s3_suffix" {
  type        = string
  description = "Optional fixed suffix; when null a short random suffix is generated"
  default     = null
}

variable "kubernetes_namespace" {
  type        = string
  description = "Namespace for Helm releases and aws_eks_pod_identity_association targets"
  default     = "monitoring"
}

variable "pod_identity_service_account_names" {
  type        = map(string)
  description = "Kubernetes ServiceAccount names — must match Helm charts and Pod Identity associations"
  default = {
    mimir = "mimir"
    loki  = "loki"
    tempo = "tempo"
  }
}

variable "install_kubernetes_apps" {
  type        = bool
  description = "Install Prometheus, Grafana, Loki, Tempo via Helm after AWS infra"
  default     = true
}

variable "psa_enforce" {
  type        = string
  description = "PSA enforce mode for monitoring namespace (baseline works with upstream Helm charts; restricted may require chart tuning)"
  default     = "baseline"
}

variable "psa_warn" {
  type        = string
  description = "PSA warn mode — stricter profile for visibility without blocking pods"
  default     = "restricted"
}

variable "psa_audit" {
  type        = string
  description = "PSA audit mode"
  default     = "restricted"
}

variable "helm_wait" {
  type        = bool
  description = "Wait for Helm hooks (slower but surfaces install failures)"
  default     = true
}
