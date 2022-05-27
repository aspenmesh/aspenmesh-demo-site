provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
    config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "istio-system" {
    metadata {
          name = "istio-system"   
    }
}

resource "helm_release" "istio-base" {
  name       = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  namespace  = "istio-system"
}

resource "helm_release" "istiod" {
  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  namespace  = "istio-system"
}

resource "helm_release" "istio-ingress" {
  name       = "istio-ingress"
  #repository = "https://istio-release.storage.googleapis.com/charts"
  #chart      = "gateway"
  chart      = "https://istio-release.storage.googleapis.com/charts/gateway-1.13.3.tgz"
  namespace  = "istio-system"
}