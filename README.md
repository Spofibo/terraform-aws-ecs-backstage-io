# Terraform AWS ECS Backstage IO

This repository contains Terraform configurations to deploy [Backstage IO](https://backstage.io/) on AWS ECS. The Backstage image is expected to be configured with in-memory settings rather than using an RDS and Redis.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed
- AWS credentials configured

## Project Structure

- `alb.tf`: Configures the Application Load Balancer (ALB) for the ECS services.
- `ecr.tf`: Configures the Elastic Container Registry (ECR) for storing Docker images.
- `ecs.tf`: Configures the ECS cluster.
- `ecs_backstage_service.tf`: Configures the ECS service for Backstage.
- `main.tf`: Main configuration file that sets up the AWS provider and availability zones.
- `outputs.tf`: Defines the outputs of the Terraform configuration.
- `providers.tf`: Specifies the required providers.
- `variables.tf`: Defines the variables used in the Terraform configuration.
- `vpc.tf`: Configures the Virtual Private Cloud (VPC).

## Usage

1. Clone the repository:
    ```sh
    git clone https://github.com/Spofibo/terraform-aws-ecs-backstage-io.git
    cd terraform-aws-ecs-backstage-io
    ```

2. Initialize Terraform:
    ```sh
    terraform init
    ```

3. Review the plan:
    ```sh
    terraform plan
    ```

4. Apply the configuration:
    ```sh
    terraform apply
    ```

## Important Note

The ECS service will not work and will fail until a Backstage image has been pushed to the ECR repository. Follow these steps to build and push the Backstage image:

1. Build the Docker image:
    ```sh
    docker build -t <your-backstage-image> .
    ```

2. Tag the Docker image:
    ```sh
    docker tag <your-backstage-image>:latest <ecr_repository_url>:latest
    ```

3. Log in to ECR:
    ```sh
    aws ecr get-login-password --region <your-region> | docker login --username AWS --password-stdin <ecr_repository_url>
    ```

4. Push the Docker image to ECR:
    ```sh
    docker push <ecr_repository_url>:latest
    ```

Replace `<your-backstage-image>` with your desired image name and `<ecr_repository_url>` with the URL of your ECR repository.

## Outputs

- `ecr_backstage_repository_url`: The URL of the ECR Backstage repository.
- `backstage_docker_instructions`: Instructions for building and pushing the Docker image to ECR.
- `alb_dns_name`: The DNS name of the ALB.

## Notes

- The Backstage IO deployment is configured with in-memory settings rather than using an RDS and Redis.
- Ensure that your AWS credentials have the necessary permissions to create the resources defined in the Terraform configuration.

## License

This project is licensed under the MIT License.