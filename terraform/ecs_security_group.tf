# Create a Security Group for ECS Tasks
resource "aws_security_group" "logstash_sg" {
  name_prefix = "logstash_sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 5044
    to_port         = 5044
    protocol        = "tcp"
    security_groups = [aws_security_group.load_balancer_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
