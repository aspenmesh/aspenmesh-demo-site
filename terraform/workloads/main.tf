data "terraform_remote_state" "eks" {
  backend = "local" 
  config = {
    path = "../cluster/terraform.tfstate"
  }
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.kubernetes_host
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_ca_certificate)

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.eks.outputs.cluster_name]
  }
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.eks.outputs.kubernetes_host
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_ca_certificate)

    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.eks.outputs.cluster_name]
    }
  }
}


module "istio" {
  source = "./modules/istio"
}

module "integrations" {
  source = "./modules/integrations"
  depends_on = [module.istio]
}

module "demo_site" {
  source               = "./modules/demo-site"
  aspenmesh_demo_chart = var.aspenmesh_demo_chart
  depends_on = [module.istio]
}