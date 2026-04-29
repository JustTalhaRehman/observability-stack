resource "random_id" "bucket_suffix" {
  byte_length = 3
}

resource "random_password" "grafana_admin" {
  length  = 24
  special = false
}
