## Overview

This project is designed following best practices as recommended by HashiCorp for developing Terraform modules and organizing infrastructure as code. The primary goal of this project is to create a reusable, maintainable, and scalable infrastructure setup that leverages Terraform workspaces to manage different environments (dev, stage, prod) effectively.

### Key Features:
- **Best Practices**: The project structure follows the guidelines outlined by HashiCorp for [module composition](https://developer.hashicorp.com/terraform/language/modules/develop/composition), ensuring a clean and modular approach to infrastructure management.
- **Workspace Management**: Terraform workspaces are used to manage environment-specific configurations (dev, stage, prod) with minimal code duplication, reducing the risk of errors and simplifying the management of multiple environments.
- **Modular Design**: The infrastructure is broken down into reusable modules that encapsulate specific functionalities, such as networking, compute, data, and application layers. This modular approach allows for easy scaling and maintenance.
- **Remote State Backend**: The project uses a remote state backend (S3 with DynamoDB for locking) to store Terraform state files securely. This ensures that the state is centralized, secure, and accessible across different environments and team members, preventing state conflicts and ensuring consistency.

---

## Folder Structure

The project is organized into the following structure:
> Note: (WIP) Still adding modules

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

---

## Environments and Workspaces

This project uses Terraform workspaces to manage different environments. The environments are:

-	**dev**: Development environment
-	**stage**: Staging environment
-	**prod**: Production environment

  
```hcl
❯ terraform workspace list

   default
   dev
 * prod
   staging
```

Workspaces allow us to isolate the state of each environment, ensuring that changes in one environment do not affect others. This approach reduces code duplication and makes it easier to manage infrastructure across multiple environments.

---

## Remote State Backend

This project uses a remote state backend hosted on Amazon S3 with DynamoDB for state locking. This setup provides several benefits:

- **Centralized State Management**: The Terraform state file is stored in a centralized location, making it accessible to all team members and environments.
- **State Locking**: DynamoDB is used for state locking, ensuring that only one Terraform process can modify the state at a time, preventing conflicts and ensuring consistency.
- **Secure Storage**: The state file is securely stored in S3, with access controlled via IAM policies.

## Deploy and Destory

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

Example output

```hcl
  # module.eks.module.eks.module.kms.aws_kms_key.this[0] will be created
  + resource "aws_kms_key" "this" {
      + arn                                = (known after apply)
      + bypass_policy_lockout_safety_check = false
      + customer_master_key_spec           = "SYMMETRIC_DEFAULT"
      + description                        = "dev-eks-cluster cluster encryption key"
      + enable_key_rotation                = true
      + id                                 = (known after apply)
      + is_enabled                         = true
      + key_id                             = (known after apply)
      + key_usage                          = "ENCRYPT_DECRYPT"
      + multi_region                       = false
      + policy                             = (known after apply)
      + rotation_period_in_days            = (known after apply)
      + tags                               = {
          + "Environment"           = "dev"
          + "terraform-aws-modules" = "eks"
        }
      + tags_all                           = {
          + "Environment"           = "dev"
          + "terraform-aws-modules" = "eks"
        }
    }

  # module.eks.module.eks.module.eks_managed_node_group["initial"].module.user_data.null_resource.validate_cluster_service_cidr will be created
  + resource "null_resource" "validate_cluster_service_cidr" {
      + id = (known after apply)
    }

Plan: 70 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + configure_kubectl = "aws eks --region us-east-1 update-kubeconfig --name dev-eks-cluster"
```

 4.	Apply the Changes (use per need):
   
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

---

# Future Enhancements for EKS Cluster

As we aim to enhance our existing EKS cluster, we can leverage the latest open-source CNCF (Cloud Native Computing Foundation) graduated tools to improve scalability, security, reliability, observability, and cost efficiency. Below are the recommended enhancements:

## 1. **Infrastructure Management**

### **Terragrunt**
- **Description:** Terragrunt is a thin wrapper for Terraform that provides additional functionality for managing multiple Terraform modules, reducing duplication, and automating common workflows.
- **Implementation:** Utilize Terragrunt to manage complex Terraform configurations more efficiently. Terragrunt helps with keeping your Terraform code DRY (Don't Repeat Yourself) by promoting reusable modules, managing remote state, and handling dependencies between modules.

### **tfsec**
- **Description:** tfsec is a static analysis security scanner for Terraform code. It scans your Terraform configurations for potential security issues and best practices.
- **Implementation:** Integrate tfsec into your CI/CD pipeline to automatically scan Terraform code for security vulnerabilities before deployment, ensuring your infrastructure adheres to security best practices.

### **Terratest**
- **Description:** Terratest is a Go library that provides patterns and helper functions for writing automated tests for your Terraform code.
- **Implementation:** Use Terratest to write integration tests that validate your infrastructure code. This ensures that your Terraform modules work as expected and helps prevent regressions when making changes.

## 2. **Scalability**

### **Karpenter**
- **Description:** Karpenter is an open-source Kubernetes cluster autoscaler built to improve the efficiency and scalability of Kubernetes workloads. It automatically provisions just the right compute resources to handle the cluster’s workloads based on the actual demands, reducing infrastructure costs.
- **Implementation:** Deploy Karpenter in the EKS cluster to replace the traditional Cluster Autoscaler. Karpenter's ability to launch EC2 instances tailored to workload needs enhances scalability and optimizes resource usage.

## 3. **Security**

### **OPA (Open Policy Agent) with Gatekeeper**
- **Description:** OPA is a policy engine that allows you to enforce fine-grained policies for Kubernetes resources. Gatekeeper is an admission controller that uses OPA to enforce policies at the time of resource creation.
- **Implementation:** Deploy OPA with Gatekeeper to enforce security and compliance policies across the Kubernetes cluster, ensuring only compliant resources are allowed.

### **Falco**
- **Description:** Falco is a runtime security tool that monitors the behavior of the container and Kubernetes environment in real time, detecting unexpected activity and potential security threats.
- **Implementation:** Integrate Falco with the EKS cluster to monitor and alert on suspicious activities and security breaches.

## 4. **Reliability**

### **Velero**
- **Description:** Velero provides backup, restore, and disaster recovery capabilities for Kubernetes clusters. It allows you to safely back up your Kubernetes resources and persistent volumes.
- **Implementation:** Set up Velero to perform regular backups of the EKS cluster and automate recovery processes to improve cluster resilience.

### **LitmusChaos**
- **Description:** LitmusChaos is a chaos engineering tool that helps you identify weaknesses in your system by injecting various failure scenarios into your Kubernetes cluster.
- **Implementation:** Use LitmusChaos to run chaos experiments on the EKS cluster, testing the reliability and robustness of your applications and infrastructure.

## 5. **Observability**

### **OpenTelemetry**
- **Description:** OpenTelemetry is an open-source project that provides a set of APIs, libraries, and agents to collect distributed traces, metrics, and logs from your applications. It supports multiple backends, making it easy to integrate with existing observability tools like Prometheus, Jaeger, and Grafana.
- **Implementation:** 
  - **Tracing:** Instrument your microservices with OpenTelemetry SDKs to capture and export distributed traces. This will help in monitoring request paths across services, identifying bottlenecks, and improving application performance.
  - **Metrics:** Use OpenTelemetry to collect and export application and infrastructure metrics to Prometheus. This ensures a unified metric collection framework across all services.
  - **Logging:** Integrate OpenTelemetry’s logging capabilities with existing log aggregation systems like Loki, ensuring logs, metrics, and traces are correlated for easier debugging and analysis.


### **Prometheus & Grafana**
- **Description:** Prometheus is a leading open-source monitoring solution, and Grafana is a visualization tool that provides powerful dashboards for monitoring Kubernetes clusters.
- **Implementation:** Enhance existing observability by expanding Prometheus metrics collection and using Grafana for more comprehensive and actionable dashboards.

### **Jaeger**
- **Description:** Jaeger is a distributed tracing tool that helps monitor and troubleshoot transactions in complex microservices environments.
- **Implementation:** Deploy Jaeger to trace and monitor request paths across the microservices in the EKS cluster, improving the ability to identify performance bottlenecks and optimize latency.

### **Loki**
- **Description:** Loki is a log aggregation system designed to work seamlessly with Grafana, providing an efficient and scalable solution for collecting and querying logs.
- **Implementation:** Integrate Loki with Grafana to centralize log management and enhance the ability to debug issues across the Kubernetes cluster.

## 6. **Service Mesh**

### **Istio**
- **Description:** Istio is a service mesh that provides advanced traffic management, security, and observability across microservices within the Kubernetes environment.
- **Implementation:** Deploy Istio in the EKS cluster to gain finer control over traffic routing, improve security with mTLS, and enhance observability with detailed telemetry.

## 7. **CI/CD Integration**

### **ArgoCD**
- **Description:** ArgoCD is a declarative, GitOps continuous delivery tool for Kubernetes. It automates the deployment of applications to Kubernetes and keeps the cluster state synchronized with Git repositories.
- **Implementation:** Implement ArgoCD to automate the continuous deployment of Kubernetes applications, ensuring that the cluster state is always consistent with the desired configuration in Git.

### **Tekton**
- **Description:** Tekton is a powerful Kubernetes-native CI/CD pipeline tool that allows for flexible, reusable pipeline configurations.
- **Implementation:** Set up Tekton pipelines for building, testing, and deploying Kubernetes applications, integrating seamlessly with other tools like ArgoCD for complete CI/CD automation.

## 8. **Cost Efficiency**

### **OpenCost**
- **Description:** OpenCost is an open-source tool that provides real-time cost monitoring and optimization insights for Kubernetes clusters. It helps track the costs of individual resources and workloads, enabling better cost management.
- **Implementation:** Deploy OpenCost to monitor the costs associated with running Kubernetes workloads on AWS. This tool will provide insights into cost distribution, allowing for better resource allocation and cost-saving strategies.

By implementing these enhancements, we will significantly improve the scalability, security, reliability, observability, and cost efficiency of our EKS cluster, while also enhancing our infrastructure management processes with advanced Terraform tools.

