# module "ecs" {
#   source = "terraform-aws-modules/ecs/aws"

#   cluster_name = "logstash-ecs-cluster"

#   cluster_configuration = {
#     execute_command_configuration = {
#       logging = "OVERRIDE"
#       log_configuration = {
#         cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
#       }
#     }
#   }

#   # Cluster capacity providers
#   default_capacity_provider_strategy = {
#     FARGATE = {
#       weight = 50
#       base   = 20
#     }
#     FARGATE_SPOT = {
#       weight = 50
#     }
#   }

#   services = {
#     logstash_service = {
#       cpu    = 1024
#       memory = 4096

#       # Container definition(s)
#       container_definitions = {

#         logstash_container = {
#           cpu       = 512
#           memory    = 1024
#           essential = true
#           image     = "${module.ecr.repository_url}:latest"

#           portMappings = [
#             {
#               containerPort = 8080
#               hostPort      = 8080
#               protocol      = "tcp"
#             }
#           ]


#           enable_cloudwatch_logging = false
#           logConfiguration = {
#             logDriver = "awsfirelens"
#             options = {
#               Name                    = "firehose"
#               region                  = "eu-west-1"
#               delivery_stream         = "my-stream"
#               log-driver-buffer-limit = "2097152"
#             }
#           }
#           memoryReservation = 100
#         }
#       }

#       load_balancer = {
#         service = {
#           target_group_arn = "arn:aws:elasticloadbalancing:eu-west-1:1234567890:targetgroup/bluegreentarget1/209a844cd01825a4"
#           container_name   = "ecs-sample"
#           container_port   = 80
#         }
#       }

#       subnet_ids = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]
#       security_group_ingress_rules = {
#         alb_3000 = {
#           description                  = "Service port"
#           from_port                    = 8080
#           to_port                      = 8080
#           ip_protocol                  = "tcp"
#           referenced_security_group_id = "sg-12345678"
#         }
#       }
#       security_group_egress_rules = {
#         all = {
#           ip_protocol = "-1"
#           cidr_ipv4   = "0.0.0.0/0"
#         }
#       }
#     }
#   }

#   tags = {
#     Environment = "Development"
#     Project     = "Example"
#   }
# }
