module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "demo_vpc"
  cidr = "10.0.0.0/16"

  azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets  = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  database_subnets = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
  public_subnets   = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]

  create_igw         = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
