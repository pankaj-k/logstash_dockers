##############################
# ECS needs MINIMAL permissions while the applications running in the containers need more permissions.

# Use taskRoleArn for Logstash permissions (accessing S3, Secrets Manager, etc.)
# Use executionRoleArn for ECS operations (pulling images, logging, etc.)

# =======================
# 1. ECS Execution Role
# =======================
# Used by ECS to pull images, manage logs, and access AWS services like SSM.

data "aws_iam_policy_document" "allow_aws_services_to_assume_this_role" {
  statement {
    sid     = "2"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_role" {
  name               = "ecs_role"
  assume_role_policy = data.aws_iam_policy_document.allow_aws_services_to_assume_this_role.json
}

## Attach Amazon Managed Execution Role Policy (for CloudWatch logs, secrets, etc.)
resource "aws_iam_role_policy_attachment" "ecs_role_aws_managed_policy_attachment" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


data "aws_iam_policy_document" "ecs_role_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:BatchGetImage",
      "kms:Decrypt"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "ecs_role_policy" {
  name   = "ecs_role_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.ecs_role_policy_document.json
}

resource "aws_iam_role_policy_attachment" "ecs_role_policy_attachment" {
  role = aws_iam_role.ecs_role.name
  policy_arn = aws_iam_policy.ecs_role_policy.arn
}