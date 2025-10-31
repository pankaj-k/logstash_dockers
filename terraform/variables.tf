# Globlal variables for the project
variable "region" {
  description = "AWS region for the infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "logstash_docker"
}

variable "domain_name" {
  description = "Name of the domain bought from AWS" # It makes life a little simpler if using Route53.
  type        = string
  default     = "uselesschatter.com"
}