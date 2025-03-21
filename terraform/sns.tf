# Goal: Send emails when tasks are created or stopped in ECS.
# 1. Create an SNS Topic for Email Notifications
# 2. Create an IAM Role
# 3. Create a Lambda Function to process ECS events and format emails
# 4. Set up EventBridge to trigger Lambda when a task starts or stops
# 5. Lambda sends a custom email via SNS

resource "aws_sns_topic" "ecs_alerts" {
  name = "ecs-task-alerts"
}


resource "aws_sns_topic_subscription" "ecs_alerts_email" {
  topic_arn = aws_sns_topic.ecs_alerts.arn
  protocol  = "email"
  endpoint  = "pk.241011@gmail.com" # Change this to your email
}