module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = ">= 2.2.1"

  name = join("-", [each.value, var.environment])

  create_repository = true
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration = {
    scan_on_push = true
  }

  # Optional: repository policy, e.g., to allow cross-account access
  repository_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "AllowCrossAccountPull",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::123456789012:root"
        },
        "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]
      }
    ]
  }
  EOF

  tags = var.tags
}

resource "aws_ecr_repository" "microservices" {
  for_each = toset(var.microservices)

  name = "${each.value}-${var.environment}"
}