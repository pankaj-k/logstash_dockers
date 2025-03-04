#data "aws_caller_identity" "current" {} # Need to get the aws account id to provide access to the ECR repository.

# resource "aws_ecrpublic_repository" "custom_logstash_docker_public_repo" {
#   repository_name = "custom_logstash_docker_public_repo"
#   catalog_data {
#     about_text        = "Just for testing purposes"
#     architectures     = ["ARM"]
#     description       = "Just a custom image for testing purposes."
#     operating_systems = ["Linux"]
#     usage_text        = "Just for testing purposes"
#   }
# }

resource "aws_ecr_repository" "custom_logstash_docker_private_repo" {
  name                 = "logstash-8.17.2"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = false
  }

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.logstash_docker_kms_key.arn
  }
}

data "aws_iam_policy_document" "aws_ecr_private_repository_policy_document" {
  statement {
    sid    = "aws ecr policy"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id] # This is the account id of the user.
    }

    actions = [
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
      "ecr:DeleteRepositoryPolicy",
    ]
  }
}

resource "aws_ecr_repository_policy" "aws_ecr_private_repository_policy" {
  repository = aws_ecr_repository.custom_logstash_docker_private_repo.name
  policy     = data.aws_iam_policy_document.aws_ecr_private_repository_policy_document.json
}
