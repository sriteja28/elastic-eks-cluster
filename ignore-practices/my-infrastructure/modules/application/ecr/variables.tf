variable "microservices" {
  description = "A list of microservices for which ECR repositories will be created"
  type        = list(string)
}

variable "environment" {
  description = "The environment name (e.g., dev, prod)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the ECR repositories"
  type        = map(string)
  default     = {}
}