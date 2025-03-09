# Logstash and Firehose compliant S3 bucket policy
data "aws_iam_policy_document" "s3_iam_access_policy_document" {
  statement {
    sid = "1"
    actions = [
      "s3:ListBucket",
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]
    resources = ["arn:aws:s3:::logstash-ecs-*"] # Actions allowed on bucket.
  }
  statement {
    sid = "2"
    actions = [
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
    ]
    resources = ["arn:aws:s3:::logstash-ecs-*/*"] # Actions allowed on objects in the bucket.
  }
}

resource "aws_iam_policy" "s3_aws_iam_policy" {
  name   = "s3_access_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.s3_iam_access_policy_document.json
}


