resource "aws_cloudwatch_event_rule" "ecs_task_events" {
  name        = "ecs-task-events"
  description = "Trigger when an ECS task is started or stopped"
  event_pattern = jsonencode({
    source      = ["aws.ecs"]
    detail-type = ["ECS Task State Change"]
    detail = {
      clusterArn    = ["${aws_ecs_cluster.logstash_cluster.arn}"]
      lastStatus    = ["RUNNING", "STOPPED"] # Ignore other states like PENDING, etc.
      desiredStatus = ["RUNNING", "STOPPED"]
      # RUNNING + desiredStatus RUNNING : Only triggers when a task actually starts running.
      # STOPPED + desiredStatus STOPPED : Triggers when a task is truly stopped (not just transitioning).
    }
  })
}

resource "aws_cloudwatch_event_target" "ecs_task_alert_target" {
  rule      = aws_cloudwatch_event_rule.ecs_task_events.name
  target_id = "send-to-lambda"
  arn       = aws_lambda_function.ecs_alert_lambda.arn
}

# Allow to invoke lambda 
resource "aws_lambda_permission" "eventbridge_invoke" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ecs_alert_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ecs_task_events.arn
}
