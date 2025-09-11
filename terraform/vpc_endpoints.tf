module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  vpc_id = module.vpc.vpc_id
  create = true

  create_security_group      = true
  security_group_name_prefix = "logstash-cluster-vpc-endpoints-"
  security_group_description = "VPC endpoint security group"
  security_group_rules = {
    # Ingress = allows traffic into the security group (from VPC CIDR in this case).
    # https is assumed as the services use https. So no need to explicitly open port 443.
    # Egress = allows traffic out of the security group to AWS services over https.
    # Port will be 443 as endpoints use https to talk to AWS services.
    ingress_https = {
      description = "HTTPS from VPC"
      cidr_blocks = [module.vpc.vpc_cidr_block]
    }
  }

  endpoints = {
    ecr_api = {
      service_name       = "com.amazonaws.${var.region}.ecr.api"
      service_type       = "Interface"
      subnet_ids         = module.vpc.private_subnets
    }
    ecr_dkr = {
      service_name       = "com.amazonaws.${var.region}.ecr.dkr"
      service_type       = "Interface"
      subnet_ids         = module.vpc.private_subnets
    }
    ecs = {
      service_name       = "com.amazonaws.${var.region}.ecs"
      service_type       = "Interface"
      subnet_ids         = module.vpc.private_subnets
    }
    ecs_agent = {
      service_name       = "com.amazonaws.${var.region}.ecs.agent"
      service_type       = "Interface"
      subnet_ids         = module.vpc.private_subnets
    }
    ecs_telemetry = {
      service_name       = "com.amazonaws.${var.region}.ecs.telemetry"
      service_type       = "Interface"
      subnet_ids         = module.vpc.private_subnets
    }
  }
}
