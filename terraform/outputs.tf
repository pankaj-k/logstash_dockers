# ECR Repository Outputs
output "logstash_ecr_repository_arn" {
  description = "Full ARN of the ECR repository"
  value       = module.ecr.repository_arn
}

output "logstash_ecr_repository_url" { 
  description = "URL of the ECR repository (for docker commands)"
  value       = module.ecr.repository_url
}

output "logstash_ecr_repository_name" {
  description = "Name of the ECR repository"
  value       = module.ecr.repository_name
}

output "logstash_ecr_registry_id" {
  description = "Registry ID where the repository was created"
  value       = module.ecr.repository_registry_id
}