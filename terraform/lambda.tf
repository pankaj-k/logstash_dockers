resource "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "code/lambda_function.py"
  output_path = "lambda_function.zip"
}

resource "aws_lambda_function" "ecs_alert_lambda" {
  filename      = "ecs_alert_lambda.zip"
  function_name = "ECSAlertLambda"
  role          = aws_iam_role.logstash_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  timeout       = 10

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.ecs_alerts.arn
    }
  }
}
