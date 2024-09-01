provider "aws" {
  region = var.region
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
  name   = var.name
  region = var.region

  tags = {
    Environment = var.environment
  }
}

module "vpc" {
  source = "../../modules/networking/vpc"

  vpc_name  = "${local.name}-vpc"
  vpc_cidr  = "10.0.0.0/16"
  azs       = data.aws_availability_zones.available.names
  tags      = local.tags
}

module "eks" {
  source = "../../modules/compute/eks"

  cluster_name  = "${local.name}-eks"
  cluster_version = "1.30"
  vpc_id        = module.vpc.vpc_id
  subnet_ids    = module.vpc.private_subnets
  tags          = local.tags
}