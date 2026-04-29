# Security for this demo repo

## Do not commit

- Real OAuth client secrets, API tokens, or kubeconfig with live credentials
- AWS account IDs, internal ARNs, PrivateLink endpoint IDs from production
- Secrets Manager / Parameter Store **paths** from a real employer project
- Vendor or internal dashboard JSON that contains org-specific data

## Use placeholders

Examples (fictional):

- `YOUR_DOMAIN`, `YOUR_ACCOUNT_ID`, `YOUR_REGION`, `YOUR_REPO_URL`
- Secret keys in docs: `demo/grafana/admin` style — **not** copied from any internal repo

## IAM (demo vs production)

- This repo uses **least-privilege Pod Identity roles**: each workload role may only access **its** S3 bucket (see `terraform/modules/iam-observability-pod-identity`).
- Trust policies scope **`aws:SourceAccount`** and **`aws:SourceArn`** (cluster ARN) where supported — review in `main.tf` of that module.

## Pod Security Admission (PSA)

- The `monitoring` namespace gets PSA labels (`terraform/envs/demo/k8s_namespace.tf`): **enforce=baseline**, **warn/audit=restricted** by default.
- **No guarantee** that every upstream Helm chart is compatible with `restricted` enforce; the demo defaults to **baseline** to balance signal vs breakage.

## Network isolation

- **NetworkPolicies** and service mesh are **not** configured in this minimal-cost demo. Treat that as a deliberate gap documented in `docs/architecture.md` for production hardening.

## External Secrets Operator

- **Not deployed** here (fewer moving parts, lower cognitive load for a portfolio clone).
- **Production pattern:** install External Secrets Operator (or similar) and sync Grafana admin, TLS, and datasource secrets from **AWS Secrets Manager** / SSM — never from Git or long-lived Terraform state for human-facing passwords.

## Grafana database

Postgres (e.g. RDS) credentials belong in a secret store. This repo contains **no** connection strings.

## EKS logging & audit

- **Control plane logging** (api/audit/authenticator) and **CloudWatch** alarms are not enabled in Terraform in this demo — add them when you promote to a shared environment.

## If you accidentally committed a secret

Rotate the credential immediately, purge from Git history (e.g. `git filter-repo`), and treat the old value as compromised.
