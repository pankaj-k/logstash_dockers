# resource "aws_kms_key" "logstash_docker_kms_key" {
#   enable_key_rotation     = true
#   deletion_window_in_days = 7         # Minimum number of days key stays in deactivated and scheduled for deletion. 7 days is minimum you can choose. 
#   tags = {                            # This is a safe guard against accidental deletion.
#     Name  = "logstash_docker_kms_key" # The key is not used during this time.
#     owner = "logstash_docker_team"
#   }
# }

# # resource "aws_kms_alias" "alias" {
# #   name          = "alias/logstash_docker_kms_key" # Mandatory to have alias/ in the name.
# #   target_key_id = aws_kms_key.logstash_docker_kms_key.id
# # }

# KMS module to create key + alias
module "logstash_kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 1.1" # lock to latest minor release

  aliases                 = ["alias/logstash_docker_kms_key"]
  enable_key_rotation     = true
  deletion_window_in_days = 7

  # Account root (full administration)
  key_owners = [
    data.aws_caller_identity.current.arn
  ]

  # Roles or users that can use the key
  key_users = [
    aws_iam_role.logstash_docker_role.arn
  ]

  tags = {
    Name  = "logstash_docker_kms_key"
    Owner = "logstash_docker_team"
  }
}