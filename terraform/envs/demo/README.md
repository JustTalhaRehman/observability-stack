# Demo environment — one-shot portfolio deploy

Creates a **minimal billable** stack on AWS:

- VPC (single NAT by default)
- EKS (one `t3.large` node by default — fits Prometheus + Loki + Tempo + Grafana)
- S3 buckets for `mimir`, `loki`, `tempo`
- **EKS Pod Identity** (no IRSA): IAM roles + `aws_eks_pod_identity_association`
- **Helm**: `prometheus`, `loki` (SingleBinary + S3), `tempo` (S3), `grafana` (datasources wired)
- **PSA**: `monitoring` namespace created by Terraform with **Pod Security Admission** labels (`enforce=baseline`, `warn/audit=restricted` by default — override via `psa_*` variables)

**Mimir** is intentionally **not** installed via Helm (too heavy for a single small node). The **Mimir** bucket and Pod Identity role/association are still created so you can add the chart later when you scale the cluster.

## Prerequisites

- AWS CLI + credentials (`aws sts get-caller-identity`)
- Terraform `>= 1.5`
- **Helm 3** on `PATH` (the Helm provider shells out to the CLI)

## Recommended: one command from repo root

```bash
./scripts/terraform-apply-demo.sh
```

This runs Terraform **twice**: first the AWS + Pod Identity graph (so the EKS API exists), then the full apply including Helm. Pass flags through, e.g.:

```bash
./scripts/terraform-apply-demo.sh -auto-approve
```

## Manual

```bash
cd terraform/envs/demo
terraform init
# optional: cp terraform.tfvars.example terraform.tfvars
./../../../scripts/terraform-apply-demo.sh
```

## After apply

```bash
terraform output -raw configure_kubectl | sh
terraform output -raw grafana_access
terraform output -raw grafana_admin_password
```

Open Grafana at `http://localhost:3000` while port-forward is running.

## Cost / cleanup

EKS control plane, NAT, EC2, and S3 usage are **not free**. When finished:

```bash
terraform destroy
```

