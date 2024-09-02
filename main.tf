provider "aws" {
  region = local.region
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
  }
}

data "aws_availability_zones" "available" {}

locals {
  name = terraform.workspace == "dev" ? var.name_dev : terraform.workspace == "staging" ? var.name_staging : var.name_prod

  region = terraform.workspace == "dev" ? var.region_dev : terraform.workspace == "staging" ? var.region_staging : var.region_prod

  environment = terraform.workspace == "dev" ? var.environment_dev : terraform.workspace == "staging" ? var.environment_staging : var.environment_prod

  vpc_cidr = terraform.workspace == "dev" ? var.vpc_cidr_dev : terraform.workspace == "staging" ? var.vpc_cidr_staging : var.vpc_cidr_prod
}

module "vpc" {
  source = "../../modules/networking/vpc"

  vpc_name  = "${local.name}-vpc"
  vpc_cidr  = local.vpc_cidr
  azs       = data.aws_availability_zones.available.names
  tags      = {
    Environment = local.environment
  }
}

module "eks" {
  source = "../../modules/compute/eks"

  cluster_name  = "${local.name}-eks"
  cluster_version = var.cluster_version
  vpc_id        = module.vpc.vpc_id
  subnet_ids    = module.vpc.private_subnets
  tags          = {
    Environment = local.environment
  }
}

module "ecr" {
  source  = "../../modules/application/ecr"
  microservices = ["service1", "service2"]
  environment   = local.environment
  tags          = {
    Environment = local.environment
  }
}