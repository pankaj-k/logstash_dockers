
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]  # Use your actual VPC ID or a variable
  }
}

# Create a Security Group for ECS Tasks
resource "aws_security_group" "ecs_tasks_sg" {
  name_prefix = "ecs-tasks-sg"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 5044
    to_port     = 5044
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow public access (change if needed)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}