Multi-Tier Web Application Deployment on AWS EKS
This project demonstrates a professional-grade deployment of a multi-tier application (Spring Boot & MySQL) on an Amazon EKS (Elastic Kubernetes Service) cluster. The deployment leverages Helm for orchestration and the AWS Load Balancer Controller to manage external traffic via an Application Load Balancer (ALB).

🏗️ Architecture Overview
The application is architected as a set of decoupled microservices to ensure high availability and self-healing:

Frontend/API: A Spring Boot application (bank-app).

Database: A MySQL instance with persistent storage.

Ingress: Managed by the AWS Load Balancer Controller, exposing the app via a public-facing ALB.

🛠️ Technical Stack
Orchestration: Kubernetes (EKS).

Package Management: Helm.

Cloud Provider: AWS (IAM, EKS, ALB, ACM).

Storage: PersistentVolumes (PV) and Claims (PVC) using hostPath for node-level persistence.

Configuration: ConfigMaps for environment-specific properties.

🚀 Deployment Steps
1. Persistent Storage & Config
We first establish the database layer with persistent storage to ensure data survives pod restarts:

PersistentVolume: Defined with a 1Gi capacity and ReadWriteOnce access mode.

ConfigMap: Decouples database credentials and connection strings from the application code.

2. AWS Load Balancer Controller Setup
To bridge Kubernetes Ingress and AWS Infrastructure, the AWS Load Balancer Controller was installed via Helm:

IAM Trust Relationship: Configured an IAM role with an OIDC provider trust policy to allow the controller to manage AWS resources.

ServiceAccount: Created in the kube-system namespace to associate the IAM role with the controller pods.

Helm Installation: Deployed the controller using the eks/aws-load-balancer-controller chart.

3. Exposing the Application
Due to the absence of a professional domain, nip.io was utilized to provide a valid wildcard DNS for testing.

Ingress Configuration Snippet:

YAML
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-allapp
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
spec:
  rules:
    - host: saas.885740665747.nip.io  # Dynamic DNS via nip.io
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: bank-app-service
                port:
                  number: 80
Note: The AWS Load Balancer Controller automatically provisions an ALB and configures listeners based on these annotations.

🛡️ Reliability & Resilience
High Availability: The application deployment is configured with replicas: 2 to ensure the service remains operational even if a single pod fails.

Resource Limits: Defined CPU and Memory limits (e.g., 700Mi memory limit) to prevent resource contention and ensure cluster stability.

Self-Healing: Kubernetes automatically detects container failures and restarts pods to maintain the desired state.

📝 Project Highlights
Successfully implemented a full CI/CD-ready infrastructure.

Managed sensitive cloud permissions using IAM Roles for Service Accounts (IRSA).

Configured advanced ingress features including SSL/TLS termination via AWS Certificate Manager (ACM).
