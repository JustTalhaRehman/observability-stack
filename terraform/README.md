# Terraform — portfolio demo (AWS + Helm)

End state after **`./scripts/terraform-apply-demo.sh`** from the repo root:

| Layer | What runs |
|-------|-----------|
| Network | VPC + public/private subnets + **single NAT** (cheaper lab default) |
| Compute | EKS managed node group (**1× t3.large** default) |
| Identity | **EKS Pod Identity** — `eks-pod-identity-agent` add-on + IAM roles + `aws_eks_pod_identity_association` (**IRSA disabled**) |
| Storage | Three encrypted S3 buckets (`mimir`, `loki`, `tempo`) |
| Kubernetes apps | Helm: Prometheus (minimal), Loki (SingleBinary → S3), Tempo (S3), Grafana |

**IRSA is not used.** Service accounts do **not** need `eks.amazonaws.com/role-arn`; AWS maps `(cluster, namespace, service_account)` to the IAM role via Pod Identity associations.

**IAM:** one role per component with **S3 limited to that bucket only**, plus trust **scoped to the cluster ARN** (`aws:SourceArn`). **PSA** labels are applied to the `monitoring` namespace (`k8s_namespace.tf`). See [docs/architecture.md](../docs/architecture.md) for the full narrative.

## Layout

| Path | Purpose |
|------|---------|
| `modules/vpc` | VPC + subnets |
| `modules/eks` | EKS + managed nodes + **Pod Identity agent** add-on (`enable_irsa = false`) |
| `modules/s3-observability` | Per-component buckets |
| `modules/iam-observability-pod-identity` | IAM + `aws_eks_pod_identity_association` |
| `envs/demo` | Wires everything + Helm releases |

## Commands

See [envs/demo/README.md](envs/demo/README.md).

## Helm chart pins

Chart versions are in `envs/demo/locals.tf` (`helm_release_versions`) and referenced from `helm.tf`. Bump there when you upgrade.
