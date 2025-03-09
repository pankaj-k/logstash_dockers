# Generate random string for unique bucket names
resource "random_id" "bucket_suffix" {
  byte_length = 8
}

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

# # Always encrypt by default
# resource "aws_s3_bucket_server_side_encryption_configuration" "logstash_ecs_lb_access_logs_encryption" {
#   bucket = aws_s3_bucket.logstash_ecs_lb_access_logs.id
#   rule {
#     apply_server_side_encryption_by_default {
#       kms_master_key_id = aws_kms_key.logstash_docker_kms_key.key_id
#       sse_algorithm     = "aws:kms"
#     }
#   }
# }
