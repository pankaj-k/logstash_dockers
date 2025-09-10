
provider "aws" {
  region = var.region
}


# Terraform state in S3 bucket. bucket variable needs a hard coded pre-existing bucket name. Terraform 
# cannot create a bucket to store state. I created it manually. 
terraform {
  required_version = ">= 1.7.0, < 2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0" # pick a modern version
    }
  }


  backend "s3" {
    bucket = "store-tf-state-54fwty2045"
    key    = "var.project_name/terraform.tfstate"
    region = "us-east-1" # This need not be same as the region where the resources are created.
  }
}
