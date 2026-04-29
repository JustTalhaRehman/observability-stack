#!/usr/bin/env bash
# Free local cluster only ($0). Requires: kind, kubectl.
set -euo pipefail

CLUSTER_NAME="${CLUSTER_NAME:-observability-demo}"

if ! command -v kind >/dev/null 2>&1; then
  echo "Install kind: https://kind.sigs.k8s.io/docs/user/quick-start/"
  exit 1
fi

kind create cluster --name "${CLUSTER_NAME}" || true
kubectl cluster-info
echo "Next: install charts from upstream Helm repos into a namespace (e.g. monitoring), or use terraform/envs/demo for AWS."
