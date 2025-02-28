provider "aws" {
  region = var.region

  default_tags {
    tags = {
      terraform   = "true"
      environment = "POC"
      department  = "DevOps"
      application = "Backstage IO"
      cost_center = "1234567"
      owner       = "Alex Budurovici"
      repository  = "https://github.com/Spofibo/terraform-aws-ecs-backstage-io"
    }
  }
}

data "aws_availability_zones" "available" {}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}
