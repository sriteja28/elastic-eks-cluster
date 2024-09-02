# terraform.tfvars.tpl

name       = "${WORKSPACE_NAME}"
region     = "${WORKSPACE_REGION}"
environment = "${WORKSPACE_ENV}"
vpc_cidr   = "${WORKSPACE_VPC_CIDR}"

# Common configuration for all environments
cluster_version = "1.30"