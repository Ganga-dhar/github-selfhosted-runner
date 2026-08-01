# 🚀 Secure Self-Hosted GitHub Actions Runner on AWS Using Terraform & OIDC

## 📌 Project Overview

This project demonstrates the design and implementation of a secure, scalable, and automated self-hosted GitHub Actions runner infrastructure on AWS.

As part of modern DevOps practices, organizations require secure CI/CD execution environments without relying on shared hosted runners or storing long-lived cloud credentials. This solution provisions an AWS EC2-based GitHub Actions runner using Terraform Infrastructure as Code (IaC) and integrates GitHub Actions with AWS using OpenID Connect (OIDC) federation for secure, passwordless authentication.

The entire infrastructure lifecycle is automated using reusable Terraform modules, following cloud engineering best practices around security, modularity, and maintainability.

## 🎯 Objectives

- Build a dedicated self-hosted GitHub Actions runner environment on AWS EC2
- Automate infrastructure provisioning using reusable Terraform modules
- Implement secure AWS authentication using GitHub OIDC federation
- Eliminate the need for storing AWS access keys in GitHub Secrets
- Apply least privilege IAM permissions for CI/CD workflows
- Enable repeatable and consistent infrastructure deployments

## 🏗️ High-Level Architecture

The solution includes:

- **AWS VPC Module**
  - VPC creation
  - Public/private subnet architecture
  - Route tables
  - Internet Gateway / NAT Gateway configuration

- **EC2 Runner Module**
  - Provisioning GitHub Actions self-hosted runner instance
  - Automated runner installation using EC2 user data
  - Runner service configuration

- **Security Group Module**
  - Controlled network access
  - Least privilege inbound/outbound rules

- **IAM Module**
  - EC2 IAM role and policies
  - GitHub OIDC identity provider
  - IAM trust relationship for GitHub Actions workflows

- **GitHub Actions Workflow**
  - Secure AWS authentication using OIDC
  - Terraform plan and apply automation
  - Deployment execution on self-hosted runner


### High-Level deployment Steps

1. **Infrastructure Code Commit**
   - Developer pushes Terraform code and GitHub Actions workflow changes to the repository.

2. **GitHub Actions Trigger**
   - Workflow starts based on configured branch events (push/pull request/manual trigger).

3. **Secure AWS Authentication**
   - GitHub Actions authenticates with AWS using OIDC federation.
   - No AWS access keys are stored in GitHub Secrets.

4. **IAM Role Assumption**
   - GitHub assumes an AWS IAM role based on trust policy conditions.
   - Temporary AWS credentials are generated for the workflow.

5. **Terraform Execution**
   - GitHub Actions runs Terraform commands:
     - Terraform Init
     - Terraform Validate
     - Terraform Plan
     - Terraform Apply

6. **AWS Infrastructure Provisioning**
   - Terraform creates:
     - VPC networking components
     - Security Groups
     - IAM roles and policies
     - EC2 instance for GitHub runner

7. **EC2 Runner Bootstrap**
   - EC2 user data automatically:
     - Installs required dependencies
     - Downloads GitHub Actions runner package
     - Registers runner with GitHub repository
     - Configures runner as a service

8. **CI/CD Job Execution**
   - GitHub Actions jobs are executed on the self-hosted EC2 runner.
   - Runner securely performs build, test, Terraform, or deployment activities.

9. **Infrastructure Lifecycle Management**
   - All infrastructure changes are managed through Terraform version control and GitHub workflows.

