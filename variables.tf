variable "name_dev" {
  description = "The name prefix for the dev environment"
  type        = string
}

variable "region_dev" {
  description = "The AWS region for the dev environment"
  type        = string
}

variable "environment_dev" {
  description = "Environment name for the dev environment"
  type        = string
}

variable "vpc_cidr_dev" {
  description = "The CIDR block for the VPC in the dev environment"
  type        = string
}

variable "name_staging" {
  description = "The name prefix for the staging environment"
  type        = string
}

variable "region_staging" {
  description = "The AWS region for the staging environment"
  type        = string
}

variable "environment_staging" {
  description = "Environment name for the staging environment"
  type        = string
}

variable "vpc_cidr_staging" {
  description = "The CIDR block for the VPC in the staging environment"
  type        = string
}

variable "name_prod" {
  description = "The name prefix for the prod environment"
  type        = string
}

variable "region_prod" {
  description = "The AWS region for the prod environment"
  type        = string
}

variable "environment_prod" {
  description = "Environment name for the prod environment"
  type        = string
}

variable "vpc_cidr_prod" {
  description = "The CIDR block for the VPC in the prod environment"
  type        = string
}

variable "cluster_version" {
  description = "The Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.30"
}