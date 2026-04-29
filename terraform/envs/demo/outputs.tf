output "vpc_id" {
  description = "VPC hosting the EKS cluster and NAT gateway."
  value       = module.vpc.vpc_id
}

output "eks_cluster_name" {
  description = "Name passed to aws eks update-kubeconfig."
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Kubernetes API endpoint (TLS)."
  value       = module.eks.cluster_endpoint
}

output "configure_kubectl" {
  description = "Shell one-liner to merge kubeconfig for this cluster."
  value       = module.eks.configure_kubectl
}

output "s3_bucket_names" {
  description = "Per-component buckets (mimir ready for future Helm; loki/tempo used by charts)."
  value       = module.s3_observability.bucket_ids
}

output "pod_identity_role_arns" {
  description = "Least-privilege IAM roles: one per component, S3 scoped to that bucket only; bound via Pod Identity associations (no IRSA annotations)."
  value       = module.iam_observability_pod_identity.role_arns
}

output "grafana_admin_password" {
  description = "Generated admin password (lab only). Prefer External Secrets Operator + Secrets Manager in production — see docs/SECURITY.md."
  sensitive   = true
  value       = random_password.grafana_admin.result
}

output "grafana_access" {
  description = "Port-forward to Grafana Service (no LoadBalancer = no extra LB hourly cost)."
  value       = "kubectl -n ${var.kubernetes_namespace} port-forward svc/graf-grafana 3000:80"
}

output "cost_estimate_note" {
  description = "Rough order-of-magnitude for a 1-node demo in a typical region — always verify with the AWS Pricing Calculator."
  value       = "Approximate monthly (on-demand, public pricing): EKS control plane ~$72 + 1× t3.large ~$60 + single NAT Gateway ~$32 + data transfer/S3 pennies–dollars. Total often ~$160–220 before tax; SPOT/scheduled shutdown lowers this."
}

output "troubleshooting_commands" {
  description = "When Grafana has no Loki/Tempo data, check pod health and recent logs."
  value       = <<-EOT
    kubectl -n ${var.kubernetes_namespace} get pods
    kubectl -n ${var.kubernetes_namespace} logs -l app.kubernetes.io/name=loki --tail=100 --all-containers=true
    kubectl -n ${var.kubernetes_namespace} logs -l app.kubernetes.io/name=tempo --tail=100 --all-containers=true
    kubectl -n ${var.kubernetes_namespace} get svc
  EOT
}
