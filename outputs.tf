### ECR
output "ecr_backstage_repository_url" {
  description = "The URL of the ECR Backstage repository"
  value       = module.ecr_backstage.repository_url
}

output "backstage_docker_instructions" {
  description = "The URL of the ECR Backstage repository"
  value = {
    "0.login" = "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${module.ecr_backstage.repository_url}"
    "1.build" = "docker build -t backstage DOCKERFILE_PATH"
    "2.tag"   = "docker tag backstage:latest ${module.ecr_backstage.repository_url}:latest"
    "3.push"  = "docker push ${module.ecr_backstage.repository_url}:latest"
  }
}

### ALB
output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.alb.dns_name	
}