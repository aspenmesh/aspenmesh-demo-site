provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

module "eks-cluster" {
  source = "./modules/eks-cluster"
}

module "istio" {
  source = "./modules/istio"
}

module "prometheus" {
  source = "./modules/integrations/prometheus"
}

module "grafana" {
  source = "./modules/integrations/grafana"
}

module "kiali" {
  source = "./modules/integrations/kiali"
}

module "demo-site" {
  source = "./modules/demo-site"
}