variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type        = string
  description = "EKS Kubernetes version"
  default     = "1.31"
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnets for the cluster and nodes"
}

variable "cluster_endpoint_public_access" {
  type        = bool
  description = "Allow public API endpoint (convenient for lab; tighten for prod)"
  default     = true
}

variable "cluster_endpoint_private_access" {
  type    = bool
  default = true
}

variable "cluster_addons" {
  type        = map(any)
  description = "Extra EKS add-ons merged on top of eks-pod-identity-agent"
  default     = {}
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "node_min_size" {
  type    = number
  default = 1
}

variable "node_max_size" {
  type    = number
  default = 4
}

variable "node_desired_size" {
  type    = number
  default = 2
}

variable "node_capacity_type" {
  type        = string
  description = "ON_DEMAND or SPOT"
  default     = "ON_DEMAND"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "aws_region" {
  type        = string
  description = "Region for kubectl configure hint in outputs"
}
