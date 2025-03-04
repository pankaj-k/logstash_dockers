
provider "aws" {
  region = var.region
}

# Terraform state in S3 bucket. bucket variable needs a hard coded pre-existing bucket name. Terraform 
# cannot create a bucket to store state. I created it manually. 
terraform {
  backend "s3" {
    bucket = "store-tf-state-54fwty2045"
    key    = "logstash_docker_project/terraform.tfstate"
    region = "us-east-1" # This need not be same as the region where the resources are created.
  }
}
