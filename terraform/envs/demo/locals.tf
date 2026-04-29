locals {
  cluster_name = "${var.project_name}-eks"

  s3_suffix_effective = coalesce(var.s3_suffix, random_id.bucket_suffix.hex)
  s3_prefix_effective = coalesce(var.s3_name_prefix, "${var.project_name}-obs")
  helm_release_versions = {
    prometheus = "25.27.0"
    loki       = "6.6.2"
    tempo      = "1.10.3"
    grafana    = "8.5.12"
  }

  # Single place for AWS resource tags (modules + provider default_tags).
  resource_tags = merge(
    var.default_tags,
    {
      demo_profile = "minimal-portfolio"
    }
  )
}
