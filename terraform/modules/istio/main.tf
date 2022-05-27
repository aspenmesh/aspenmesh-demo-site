resource "kubernetes_namespace" "istio-system" {
  metadata {
    name = var.root_namespace
  }
}

resource "helm_release" "istio-base" {
  name       = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  namespace  = var.root_namespace
}

resource "helm_release" "istiod" {
  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  namespace  = var.root_namespace
}

resource "helm_release" "istio-ingress" {
  name = "istio-ingress"
  #repository = "https://istio-release.storage.googleapis.com/charts"
  #chart      = "gateway"
  chart     = "https://istio-release.storage.googleapis.com/charts/gateway-1.13.3.tgz"
  namespace = var.root_namespace
}