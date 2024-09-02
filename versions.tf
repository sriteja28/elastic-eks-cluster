terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.38"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.8"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.20"
    }
  }

  ##  Used for end-to-end testing on project; update to suit your needs
  backend "s3" {
    bucket = "terraform-state-bucket-sri"
    region = "us-east-1"
    key    = "eks/infra/state/terraform.tfstate"
    dynamodb_table = "terraform-state-lock"
  }
}