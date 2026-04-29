#!/usr/bin/env bash
# One-command portfolio deploy: two Terraform applies so EKS exists before Helm/Kubernetes providers authenticate.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TF_DIR="${ROOT}/terraform/envs/demo"

echo "==> Phase A: VPC + S3 + EKS + Pod Identity (no Helm yet)"
terraform -chdir="${TF_DIR}" apply \
  -target=random_id.bucket_suffix \
  -target=random_password.grafana_admin \
  -target=module.vpc \
  -target=module.s3_observability \
  -target=module.eks \
  -target=time_sleep.wait_cluster \
  -target=module.iam_observability_pod_identity \
  "$@"

echo "==> Phase B: Helm (Prometheus, Loki, Tempo, Grafana)"
terraform -chdir="${TF_DIR}" apply "$@"

echo "Done. Grafana: terraform -chdir=${TF_DIR} output -raw grafana_access"
echo "Admin password: terraform -chdir=${TF_DIR} output -raw grafana_admin_password"
