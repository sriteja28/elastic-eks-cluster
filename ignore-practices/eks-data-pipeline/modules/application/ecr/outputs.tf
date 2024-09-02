output "ecr_repository_uris" {
  description = "The URIs of the ECR repositories"
  value       = { for ms, repo in aws_ecr_repository.microservices : ms => repo.repository_url }
}