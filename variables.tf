variable "region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "shared-services"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "ecs_services" {
  description = "The services in the ECS cluster"
  type = map(object({
    name           = string
    container_port = number
  }))
  default = {
    "backstage" = {
      name           = "backstage"
      container_port = 7007
    }
  }
}