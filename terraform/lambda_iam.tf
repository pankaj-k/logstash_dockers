data "aws_iam_policy_document" "lambda_policy_doc" {
  statement {
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    actions   = ["sns:Publish"]
    effect    = "Allow"
    resources = [aws_sns_topic.ecs_alerts.arn]
  }

  statement {
    actions   = ["ecs:DescribeTasks", "ecs:ListTasks", "ecs:DescribeTaskDefinition"]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "ecs_alert_lambda_policy"
  description = "Policy for Lambda to send SNS alerts and read ECS task status"
  policy      = data.aws_iam_policy_document.lambda_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.logstash_role.name
}
