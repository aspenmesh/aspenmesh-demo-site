module "prometheus" {
  source = "./prometheus"
}

module "grafana" {
  source = "./grafana"
}

module "kiali" {
  source = "./kiali"
}