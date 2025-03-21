# Generate random string for unique bucket names
resource "random_id" "bucket_suffix" {
  byte_length = 8
}

############################################################
# Create a bucket for Loadbalancer to write access logs
############################################################


# Create S3 bucket with random suffix
resource "aws_s3_bucket" "logstash_ecs_lb_access_logs" {
  bucket        = "logstash-ecs-lb-access-logs-${random_id.bucket_suffix.hex}"
  force_destroy = true
}


resource "aws_s3_bucket_versioning" "logstash_ecs_lb_access_logs_versioning" {
  bucket = aws_s3_bucket.logstash_ecs_lb_access_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/enable-access-logging.html
# Loadbalancer can write to S3 buckets which have Amazon S3-managed encryption keys (SSE-S3).
# SSE-KMS is not supported. Hence we need to use SSE-S3.  

# Always encrypt by default
resource "aws_s3_bucket_server_side_encryption_configuration" "logstash_ecs_lb_access_logs_encryption" {
  bucket = aws_s3_bucket.logstash_ecs_lb_access_logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
