variable "name" {
  description = "The name prefix for all resources"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}