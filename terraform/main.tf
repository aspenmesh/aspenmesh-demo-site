provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = module.eks_blueprints.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks_blueprints.eks_cluster_id]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks_blueprints.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      command     = "aws"
      args = ["eks", "get-token", "--cluster-name", module.eks_blueprints.eks_cluster_id]
    }
  }
}

data "aws_availability_zones" "available" {}

locals {
  vpc_cidr     = "10.0.0.0/16"
  vpc_name     = join("-", [var.tenant, var.environment, var.zone, "vpc"])
  azs          = slice(data.aws_availability_zones.available.names, 0, 3)
  cluster_name = join("-", [var.tenant, var.environment, var.zone, "eks"])
}

module "aws_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = local.vpc_name
  cidr = local.vpc_cidr
  azs  = local.azs

  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 10)]

  enable_nat_gateway   = true
  create_igw           = true
  enable_dns_hostnames = true
  single_nat_gateway   = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }
}

module "eks_blueprints" {
  source      = "./modules/eks-aws-main"
  tenant      = var.tenant
  environment = var.environment
  zone        = var.zone

  vpc_id             = module.aws_vpc.vpc_id
  private_subnet_ids = module.aws_vpc.private_subnets

  cluster_version = "1.22"

  managed_node_groups = {
    mg_4 = {
      node_group_name = "managed-ondemand"
      instance_types  = ["m5.large"]
      min_size        = "2"
      subnet_ids      = module.aws_vpc.private_subnets
    }
  }
}

#module "eks_cluster" {
#  source = "./modules/eks-cluster"
#}

module "istio" {
  source = "./modules/istio"
}

module "integrations" {
  source = "./modules/integrations"
}

module "demo_site" {
  source = "./modules/demo-site"
  aspenmesh_demo_chart = var.aspenmesh_demo_chart
}