module "ecr" {
  source          = "terraform-aws-modules/ecr/aws"
  repository_name = "logstash-8.17.2"

  # Repository configuration
  repository_image_tag_mutability = "MUTABLE" # You can push a new image with the same tag name, and it will replace the previous image
  repository_force_delete         = true      # Force delete the repository even if it contains images

  # Image scanning configuration
  repository_image_scan_on_push = false

  # Encryption configuration
  repository_encryption_type = "KMS"
  repository_kms_key         = module.logstash_kms.key_arn

  create_lifecycle_policy = false

  # Repository policy
  create_repository_policy = true
  repository_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "aws ecr policy"
        Effect = "Allow"
        Principal = {
          AWS = data.aws_caller_identity.current.account_id
        }
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeRepositories",
          "ecr:GetRepositoryPolicy",
          "ecr:ListImages",
          "ecr:DeleteRepository",
          "ecr:BatchDeleteImage",
          "ecr:SetRepositoryPolicy",
          "ecr:DeleteRepositoryPolicy"
        ]
      }
    ]
  })

  tags = {
    Name        = "logstash-ecr-repository"
    Environment = "dev" # Adjust as needed
  }

}
