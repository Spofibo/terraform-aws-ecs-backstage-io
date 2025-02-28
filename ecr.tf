module "ecr_backstage" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "backstage"

  repository_image_tag_mutability = "MUTABLE"
  repository_image_scan_on_push   = "false"

  repository_force_delete	= true

  # repository_read_write_access_arns = ["arn:aws:iam::012345678901:role/terraform"]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 5 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 5
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
}
