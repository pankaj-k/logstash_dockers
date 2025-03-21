# =======================
# 2. ECS Task Role
# =======================
# Used by Application running in ECS tasks to access application-specific services like S3, KMS, etc.
# Here it means Logstash. Hence it is called logstash_role.

data "aws_iam_policy_document" "allow_aws_services_to_assume_this_task_role" {
  statement {
    sid     = "1"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
  statement {
    sid     = "2"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}


# Create role for application running in ECS task.
resource "aws_iam_role" "logstash_role" {
  name               = "logstash_role"
  assume_role_policy = data.aws_iam_policy_document.allow_aws_services_to_assume_this_task_role.json
}

# Just for debugging. Comment it out later.
resource "aws_iam_role_policy_attachment" "ecs_task_role_ssm" {
  role       = aws_iam_role.logstash_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Add S3 access role to it so that it can read/write to S3.
# The policy is defined in s3_iam.tf
resource "aws_iam_role_policy_attachment" "attach_s3_access_policy" {
  role       = aws_iam_role.logstash_role.name
  policy_arn = aws_iam_policy.s3_aws_iam_policy.arn
}

# Add Lambda policy to it so that it can send alerts.
# The policy is defined in lambda_iam.tf
resource "aws_iam_role_policy_attachment" "attach_lambda_policy" {
  role       = aws_iam_role.logstash_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
