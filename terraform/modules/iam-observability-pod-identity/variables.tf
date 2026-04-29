variable "name_prefix" {
  type        = string
  description = "Prefix for IAM role and policy names"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name for Pod Identity associations"
}

variable "cluster_arn" {
  type        = string
  nullable    = true
  default     = null
  description = "EKS cluster ARN — adds aws:SourceArn to role trust (tighter than account-only)"
}

variable "kubernetes_namespace" {
  type        = string
  description = "Namespace where Helm creates the service account"
  default     = "monitoring"
}

variable "component_names" {
  type    = list(string)
  default = ["mimir", "loki", "tempo"]
}

variable "service_account_names" {
  type        = map(string)
  description = "Map component -> Kubernetes ServiceAccount name (must match Helm)"
  default = {
    mimir = "mimir"
    loki  = "loki"
    tempo = "tempo"
  }
}

variable "bucket_arns" {
  type        = map(string)
  description = "Map component -> S3 bucket ARN"
}

variable "tags" {
  type    = map(string)
  default = {}
}
