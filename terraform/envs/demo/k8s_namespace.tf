# PSA: enforce baseline; warn/audit restricted. If pods fail, set psa_enforce = "privileged" in tfvars.
resource "kubernetes_namespace" "monitoring" {
  count = var.install_kubernetes_apps ? 1 : 0

  metadata {
    name = var.kubernetes_namespace
    labels = {
      "pod-security.kubernetes.io/enforce" = var.psa_enforce
      "pod-security.kubernetes.io/warn"    = var.psa_warn
      "pod-security.kubernetes.io/audit"   = var.psa_audit
    }
  }

  depends_on = [module.eks, time_sleep.wait_cluster]
}
