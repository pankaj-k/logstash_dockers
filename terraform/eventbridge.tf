# TODO: Fix this. Somehow if you comment out 11 and put in 12 you get 26 emails. Always. 
# The idea was to make sure that when a task is created or destroyed I get an email. 
# Seems too much to ask. 
resource "aws_cloudwatch_event_rule" "ecs_task_events" {
  name        = "ecs-task-started"
  description = "Trigger when an ECS task is started."
  event_pattern = jsonencode({
    source      = ["aws.ecs"]
    detail-type = ["ECS Task State Change"]
    detail = {
      clusterArn    = ["${aws_ecs_cluster.logstash_cluster.arn}"]
      lastStatus    = ["STOPPED"] # Ignore other states like PENDING, etc.
      stoppedReason = ["Essential container in task exited"]
      #desiredStatus = ["RUNNING", "STOPPED"]
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
