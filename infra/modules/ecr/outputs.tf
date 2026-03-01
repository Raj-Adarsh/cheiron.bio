output "service_a_repo_url" {
  value       = aws_ecr_repository.service_a.repository_url
  description = "ECR repository URL for service_a."
}

output "service_b_repo_url" {
  value       = aws_ecr_repository.service_b.repository_url
  description = "ECR repository URL for service_b."
}