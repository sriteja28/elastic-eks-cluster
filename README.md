# My Infrastructure Project

This project is designed following best practices as recommended by HashiCorp for developing Terraform modules and organizing infrastructure as code. The primary goal of this project is to create a reusable, maintainable, and scalable infrastructure setup that leverages Terraform workspaces to manage different environments (dev, stage, prod) effectively.

## Overview

### Key Features:
- **Best Practices**: The project structure follows the guidelines outlined by HashiCorp for [module composition](https://developer.hashicorp.com/terraform/language/modules/develop/composition), ensuring a clean and modular approach to infrastructure management.
- **Workspace Management**: Terraform workspaces are used to manage environment-specific configurations (dev, stage, prod) with minimal code duplication, reducing the risk of errors and simplifying the management of multiple environments.
- **Modular Design**: The infrastructure is broken down into reusable modules that encapsulate specific functionalities, such as networking, compute, data, and application layers. This modular approach allows for easy scaling and maintenance.
- **Remote State Backend**: The project uses a remote state backend (S3 with DynamoDB for locking) to store Terraform state files securely. This ensures that the state is centralized, secure, and accessible across different environments and team members, preventing state conflicts and ensuring consistency.

## Folder Structure

The project is organized into the following structure:

```sh
my-infrastructure/
├── main.tf                     # Main configuration file that ties everything together
├── outputs.tf                  # Outputs to be used by other components or displayed after apply
├── versions.tf                 # Specifies required Terraform and provider versions
├── variables.tf                # Variables used across the project
├── terraform.tfvars            # Variable values specific to this environment
├── modules/                    # Directory containing reusable modules
│   ├── networking/             # Networking-related modules
│   │   ├── vpc/
│   │   ├── security-groups/
│   │   ├── route53/
│   ├── compute/                # Compute-related modules
│   │   ├── ec2/
│   │   ├── autoscaling/
│   │   ├── eks/
│   │   ├── ecs/
│   ├── data/                   # Data-related modules
│   │   ├── rds/
│   │   ├── dynamodb/
│   │   ├── elasticache/
│   │   ├── s3/
│   │   ├── emr/
│   ├── application/            # Application-related modules
│   │   ├── alb/
│   │   ├── iam/
│   │   ├── lambda/
│   │   ├── apigateway/
│   │   ├── ecr/
│   │   ├── helm/               # Helm charts for Kubernetes deployments
│   │   │   ├── common/         # Common Helm resources
│   │   │   ├── microservices/  # Microservices-specific Helm charts
│   │   │   │   ├── service1/
│   │   │   │   ├── service2/
│   │   │   ├── infrastructure/ # Helm charts for infrastructure components
│   │   │   │   ├── ingress/    # Ingress controllers
│   │   │   │   ├── monitoring/ # Monitoring tools (Prometheus, Grafana)
│   │   │   │   ├── logging/    # Logging tools (ELK Stack)
│   │   │   │   ├── service-mesh/ # Service mesh (Istio, Linkerd)
│   │   │   │   ├── big-data/   # Big data tools (Kafka, Spark, Hadoop)
├── tests/                      # Directory containing test configurations
│   ├── security                # Security-related tests
│   │   ├── tfsec
│   │   └── trivy
│   └── terratest               # Infrastructure tests using Terratest
├── scripts/                    # Utility scripts for managing the infrastructure
│	├── apply.sh                 # Script to apply Terraform changes
│   ├── destroy.sh               # Script to destroy Terraform-managed resources
│   ├── plan.sh                  # Script to generate a Terraform plan
└── README.md                   # This README file
```

## Environments and Workspaces

This project uses Terraform workspaces to manage different environments. The environments are:

	•	dev: Development environment
	•	stage: Staging environment
	•	prod: Production environment

    ```hcl
    ❯ terraform workspace list
     default
     dev
   * prod
     staging
    ```

Workspaces allow us to isolate the state of each environment, ensuring that changes in one environment do not affect others. This approach reduces code duplication and makes it easier to manage infrastructure across multiple environments.

## Remote State Backend

This project uses a remote state backend hosted on Amazon S3 with DynamoDB for state locking. This setup provides several benefits:

- **Centralized State Management**: The Terraform state file is stored in a centralized location, making it accessible to all team members and environments.
- **State Locking**: DynamoDB is used for state locking, ensuring that only one Terraform process can modify the state at a time, preventing conflicts and ensuring consistency.
- **Secure Storage**: The state file is securely stored in S3, with access controlled via IAM policies.

## Deply

To get started with this project, follow these steps:

	1.	Initialize Terraform:
    
    ```hcl
    terraform init
    ```
    2. Select the Workspace:
    
    ```hcl
    terraform workspace select dev  # or staging/prod
    
    ```
    3. Plan the Infrastructure:
    
    ```hcl
    terraform plan -out=terraform-plan-dev.out
    terraform show terraform-plan-dev.out
    
    ```
    4.	Apply the Changes:
   
    ```hcl
    terraform apply
    terraform apply -target="module.vpc" -auto-approve
    terraform apply -target="module.eks" -auto-approve
    terraform apply -auto-approve
    
    ```
    5. Destroy the Infrastructure (if needed):
    
    ```hcl
    terraform destroy -auto-approve
    ```

> Note: Still adding modules and configuring a github actions pipeline (WIP)