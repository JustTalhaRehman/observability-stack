variable "name" {
  type        = string
  description = "VPC name prefix"
}

variable "cidr" {
  type        = string
  description = "VPC CIDR"
  default     = "10.0.0.0/16"
}

variable "az_count" {
  type        = number
  description = "Number of AZs (min 2 for EKS)"
  default     = 2
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnet CIDRs (length must match az_count)"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnet CIDRs (length must match az_count)"
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Enable NAT gateway(s) for private subnet egress (billable)"
  default     = true
}

variable "single_nat_gateway" {
  type        = bool
  description = "Use one NAT gateway for all AZs (cheaper lab setup)"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Common resource tags"
  default     = {}
}
