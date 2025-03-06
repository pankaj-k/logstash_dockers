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

variable "vpc_cidr_block" {
  type    = string
  default = "172.16.0.0/16"
}

variable "publicA_subnet_cidr_block" {
  type    = string
  default = "172.16.1.0/24"
}

variable "publicB_subnet_cidr_block" {
  type    = string
  default = "172.16.2.0/24"
}

variable "publicC_subnet_cidr_block" {
  type    = string
  default = "172.16.3.0/24"
}

variable "az1a" {
  type    = string
  default = "us-east-1a"
}

variable "az1b" {
  type    = string
  default = "us-east-1b"
}

variable "az1c" {
  type    = string
  default = "us-east-1c"
}
