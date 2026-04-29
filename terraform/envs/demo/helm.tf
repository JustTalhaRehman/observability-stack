# Lab: Grafana password from random_password. Prod: External Secrets + Secrets Manager (docs/SECURITY.md).

resource "time_sleep" "wait_before_helm" {
  count = var.install_kubernetes_apps ? 1 : 0

  depends_on = [module.iam_observability_pod_identity]

  create_duration = "45s"
}

resource "helm_release" "prometheus" {
  count = var.install_kubernetes_apps ? 1 : 0

  name             = "prom"
  namespace        = var.kubernetes_namespace
  create_namespace = false

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = local.helm_release_versions.prometheus

  wait    = var.helm_wait
  timeout = 900

  values = [file("${path.module}/helm-values/prometheus.yaml")]

  depends_on = [
    kubernetes_namespace.monitoring[0],
    time_sleep.wait_before_helm[0],
  ]
}

resource "helm_release" "loki" {
  count = var.install_kubernetes_apps ? 1 : 0

  name             = "loki"
  namespace        = var.kubernetes_namespace
  create_namespace = false

  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  version    = local.helm_release_versions.loki

  wait    = var.helm_wait
  timeout = 900

  values = [
    templatefile("${path.module}/helm-values/loki.yaml.tftpl", {
      aws_region           = var.aws_region
      loki_bucket          = module.s3_observability.bucket_ids["loki"]
      loki_service_account = var.pod_identity_service_account_names["loki"]
    })
  ]

  depends_on = [
    kubernetes_namespace.monitoring[0],
    time_sleep.wait_before_helm[0],
  ]
}

resource "helm_release" "tempo" {
  count = var.install_kubernetes_apps ? 1 : 0

  name             = "tempo"
  namespace        = var.kubernetes_namespace
  create_namespace = false

  repository = "https://grafana.github.io/helm-charts"
  chart      = "tempo"
  version    = local.helm_release_versions.tempo

  wait    = var.helm_wait
  timeout = 900

  values = [
    templatefile("${path.module}/helm-values/tempo.yaml.tftpl", {
      aws_region            = var.aws_region
      tempo_bucket          = module.s3_observability.bucket_ids["tempo"]
      tempo_service_account = var.pod_identity_service_account_names["tempo"]
    })
  ]

  depends_on = [
    kubernetes_namespace.monitoring[0],
    time_sleep.wait_before_helm[0],
  ]
}

resource "helm_release" "grafana" {
  count = var.install_kubernetes_apps ? 1 : 0

  name             = "graf"
  namespace        = var.kubernetes_namespace
  create_namespace = false

  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = local.helm_release_versions.grafana

  wait    = var.helm_wait
  timeout = 900

  values = [
    templatefile("${path.module}/helm-values/grafana.yaml.tftpl", {
      grafana_admin_password = random_password.grafana_admin.result
      prometheus_url         = "prom-server"
      loki_url               = "loki-gateway"
      tempo_url              = "tempo:3100"
    })
  ]

  depends_on = [
    helm_release.prometheus,
    helm_release.loki,
    helm_release.tempo,
  ]
}
