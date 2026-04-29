# Provider versions: see .terraform.lock.hcl after `terraform init`.
# Helm chart versions: locals.helm_release_versions in locals.tf

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.50"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.14"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.31"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.11"
    }
  }

  # Optional remote state (uncomment and create bucket first)
  # backend "s3" {
  #   bucket         = "YOUR_TF_STATE_BUCKET"
  #   key            = "observability-stack/demo/terraform.tfstate"
  #   region         = "YOUR_REGION"
  #   encrypt        = true
  #   dynamodb_table = "YOUR_TF_LOCK_TABLE"
  # }
}
