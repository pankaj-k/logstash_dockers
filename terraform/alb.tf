module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name                       = "demo-alb"
  internal                   = false
  vpc_id                     = module.vpc.vpc_id
  security_groups            = [module.vpc.default_security_group_id]
  subnets                    = module.vpc.public_subnets
  enable_deletion_protection = false

  # Security Group rules for ALB
  security_group_ingress_rules = {
    all_http = {
      from_port   = 8080
      to_port     = 8080
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = module.vpc.vpc_cidr_block # Allow outbound traffic to VPC only from ALB.
    }
  }

  access_logs = {
    enabled = true
    prefix  = "alb"
    bucket  = module.s3_bucket_for_logs.s3_bucket_id
  }

  tags = {
    Environment = "dev"
  }
}

# Easier to create listner and target group separately out of the module.

resource "aws_lb_listener" "demo_lb_listener" {
  load_balancer_arn = module.alb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.logstash_tg.arn
  }
}

resource "aws_lb_target_group" "logstash_tg" {
  name        = "demo-lb-target-group"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  # --------------------
  # Health check settings
  # --------------------
  health_check {
    enabled             = true
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 30
    path                = "/" # Apache server root
    port                = "8080"
    protocol            = "HTTP"
    matcher             = "200" # Expect HTTP 200 OK
    timeout             = 5
  }
}