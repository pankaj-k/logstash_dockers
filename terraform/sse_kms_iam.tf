# ############### Security policies ######################################

# # Need to define in actions what is allowed to be done using the key. 
# # The principal section is all about roles and users who can use the key. 
# # In the section written it will end up in aws console as
# # "arn:aws:iam::xxxxxxxxxxxx:user/iamadmin",
# # "arn:aws:iam::xxxxxxxxxxxx:role/iot_trust_role",
# # "arn:aws:iam::xxxxxxxxxxxx:role/ec2_assume_role"
# # The resources are * so that the key can be used on all resources you want.

# # session_mgr_access_role is added otherwise you cannot copy the certs from S3 buckets.
# # This can be removed in production. This is for testing only. TODO: Remove it.

# data "aws_caller_identity" "current" {}

# resource "aws_kms_key_policy" "logstash_docker_kms_key_policy" {
#   key_id = aws_kms_key.logstash_docker_kms_key.id
#   policy = jsonencode({
#     Id = "example"
#     Statement = [
#       {
#         Action = [
#           "kms:Create*",
#           "kms:Describe*",
#           "kms:Enable*",
#           "kms:List*",
#           "kms:Put*",
#           "kms:Update*",
#           "kms:Revoke*",
#           "kms:Disable*",
#           "kms:Get*",
#           "kms:Delete*",
#           "kms:ScheduleKeyDeletion",
#           "kms:CancelKeyDeletion",
#           "kms:Encrypt*",
#           "kms:Decrypt*",
#           "kms:ReEncrypt*",
#           "kms:GenerateDataKey*",
#           "kms:Describe*"
#         ]
#         Effect = "Allow"
#         Principal = {
#           AWS = [
#             "${data.aws_caller_identity.current.arn}",
#             "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.logstash_docker_role.name}",
#             # "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.firehose_access_role.name}",
#             # "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.session_mgr_access_role.name}",
#           ]
#         }
#         Resource = "*"
#         Sid      = "iamadmin administration of the key"
#       },
#     ]
#     Version = "2012-10-17"
#   })
# }
