resource "aws_service_discovery_http_namespace" "this" {
  name        = var.project_name
  description = "CloudMap namespace for ${var.project_name}"
}

################################################################################
# Service
################################################################################
module "ecs_backstage_service" {
  source = "terraform-aws-modules/ecs/aws//modules/service"

  name        = "backstage"
  cluster_arn = module.ecs.arn

  cpu    = 512
  memory = 1024

  # Enables ECS Exec
  enable_execute_command = true

  container_definitions = {
    backstage = {
      essential = true
      image     = "${module.ecr_backstage.repository_url}:latest"
      port_mappings = [
        {
          name          = var.ecs_services["backstage"].name
          containerPort = var.ecs_services["backstage"].container_port
          protocol = "tcp"
        }
      ]

      # Example image used requires access to write to root filesystem
      readonly_root_filesystem = false

      enable_cloudwatch_logging = false

      linux_parameters = {
        capabilities = {
          add = []
          drop = [
            "NET_RAW"
          ]
        }
      }
    }
  }

  service_connect_configuration = {
    namespace = aws_service_discovery_http_namespace.this.arn
    service = {
      client_alias = {
        port     = var.ecs_services["backstage"].container_port
        dns_name = "backstage"
      }
      port_name      = var.ecs_services["backstage"].name
      discovery_name = var.ecs_services["backstage"].name
    }
  }

  load_balancer = {
    service = {
      target_group_arn = module.alb.target_groups["backstage"].arn
      container_name   = var.ecs_services["backstage"].name
      container_port   = var.ecs_services["backstage"].container_port
    }
  }

  subnet_ids = module.vpc.private_subnets
  security_group_rules = {
    alb_ingress_3000 = {
      type                     = "ingress"
      from_port                = var.ecs_services["backstage"].container_port
      to_port                  = var.ecs_services["backstage"].container_port
      protocol                 = "tcp"
      description              = "Service port"
      source_security_group_id = module.alb.security_group_id
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  service_tags = {
    "ServiceTag" = "Tag on service level"
  }
}
