# Needed to fetch your account ARN for key_owners
data "aws_caller_identity" "current" {}

# Generate random string for unique bucket names
resource "random_id" "random" {
  byte_length = 8
}