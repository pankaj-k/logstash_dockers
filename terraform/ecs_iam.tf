# Which AWS services can assume this role?
# Keep adding the services to this list who are allowed to assume this role while doing their work. 
# As of now Lambda and ecs are allowed.
# Explained more:
# The AWS Lambda service (lambda.amazonaws.com) is given permission to assume an IAM role.
# The specific role that Lambda is allowed to assume will be the IAM role that this policy is attached to.
data "aws_iam_policy_document" "allow_aws_services_to_assume_this_role" {
  statement {
    sid     = "1"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
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


# Create role used all through the project. 
# For start allow the AWS Lambda service to assume the role via the policy document allow_aws_lambda_service_to_assume_role
# defined in lambda_iam.tf
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecs_task_execution_role"
  assume_role_policy = data.aws_iam_policy_document.allow_aws_services_to_assume_this_role.json
}

# # Add S3 access role to it.
# # The policy is defined in s3_iam.tf
# resource "aws_iam_role_policy_attachment" "attach_s3_access_policy" {
#   role       = aws_iam_role.logstash_docker_role.name
#   policy_arn = aws_iam_policy.s3_aws_iam_policy.arn
# }




# Write to cloudwatch logs policy document.
data "aws_iam_policy_document" "cloudwatch_logs_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

# Create an IAM Policy using the policy document
resource "aws_iam_policy" "cloudwatch_logs_policy" {
  name        = "WriteToCloudWatchLogsPolicy"
  description = "Policy to allow writing logs to CloudWatch"
  policy      = data.aws_iam_policy_document.cloudwatch_logs_policy_document.json
}

# Attach the write to cloudwatch logs policy to the role.
resource "aws_iam_role_policy_attachment" "cloudwatch_logs_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}


# AmazonECSTaskExecutionRolePolicy is managed by AWS.
data "aws_iam_policy" "write_to_cloudwatch_logs_permission_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Attach the write to cloudwatch logs policy to the role.
resource "aws_iam_role_policy_attachment" "write_to_cloudwatch_logs_permission_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = data.aws_iam_policy.write_to_cloudwatch_logs_permission_policy.arn
}

# # Attach the glue access policy to the role.   
# # Defined in glue_iam.tf
# resource "aws_iam_role_policy_attachment" "attach_glue_policy" {
#   role       = aws_iam_role.logstash_docker_role.name
#   policy_arn = data.aws_iam_policy.glue_access_to_aws_services_permission_policy.arn
# }

# # Attach the tag policy to the role.   
# # defined in tag_iam.tf
# resource "aws_iam_role_policy_attachment" "attach_tag_policy" {
#   role       = aws_iam_role.logstash_docker_role.name
#   policy_arn = aws_iam_policy.tag_aws_iam_policy.arn
# }
