# You Cannot Use aws_iam_policy to Allow a Load Balancer to Write to an S3 Bucket

# AWS Application Load Balancers (ALBs) and Network Load Balancers (NLBs) do not use IAM roles to write access logs to an S3 bucket. Instead, they use an AWS service principal (elasticloadbalancing.amazonaws.com), which means the permissions must be granted using a resource-based policy—i.e., an aws_s3_bucket_policy.
# Key Reasons:
#     IAM Policies (aws_iam_policy) only apply to IAM users, groups, or roles.
#     Load balancers do not assume IAM roles, so they cannot use aws_iam_policy.
#     Instead, AWS services like ELB require explicit access in the bucket’s policy (aws_s3_bucket_policy)

# TIL: Loadbalancer work with a different account id. They have account id per region. So you have to use that
# and not your account id. 
# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/enable-access-logging.html#access-log-create-bucket


# Define the policy document separately
data "aws_iam_policy_document" "alb_access_logs_policy_doc" {
  statement {
    sid    = "AllowALBLogging"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::127311923021:root"] # ALB service account
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.logstash_ecs_lb_access_logs.arn}/*"]
  }
}

# Create the bucket policy using the policy document
resource "aws_s3_bucket_policy" "alb_access_logs_policy" {
  bucket = aws_s3_bucket.logstash_ecs_lb_access_logs.id
  policy = data.aws_iam_policy_document.alb_access_logs_policy_doc.json
}