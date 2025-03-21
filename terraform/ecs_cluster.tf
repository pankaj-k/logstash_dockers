resource "aws_ecs_cluster" "logstash_cluster" {
  name = "logstash_ecs_fargate_cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "logstash_ecs_fargate_cluster"
  }
}

resource "aws_cloudwatch_log_group" "ecs_logstash" {
  name              = "/ecs/logs"
  retention_in_days = 7
}
