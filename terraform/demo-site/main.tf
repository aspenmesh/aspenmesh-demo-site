provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
    config_path = "~/.kube/config"
}

resource "helm_release" "boutique" {
  name       = "boutique"
  chart      = "../../charts/aspenmesh-demo"
}