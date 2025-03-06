resource "aws_cloudwatch_log_group" "ecs_logstash" {
  name              = "/ecs/logstash"
  retention_in_days = 7
}