Automated Deployment Process Documentation
1. Overview
This document details the architecture and process of automating the deployment of services across multiple environments using Jenkins, Ansible, and HashiCorp Vault. The system is designed to handle production and non-production environments separately, ensuring secure, synchronized, and consistent deployments.

2. Architecture
Jenkins Master and Slave Nodes:

Jenkins Master: Central orchestrator for managing jobs and workflows.
Slave 1 (Prod Environment): Dedicated to deploying and managing services in the production environment.
Slave 2 (Non-Prod Environment): Handles deployment for non-production environments like UAT, Dev, and Test.
HashiCorp Vault:

Production Vault: Manages secrets for production deployments.
Non-Production Vault: Handles secrets for non-production deployments.
Both Vault instances securely store secrets, removing them from scripts to ensure secure communications between services and components.
Ansible Playbooks:

Multiple Playbooks are employed to automate deployment and configuration of services across environments, enabling version control and easy management of configurations.
Parallel Backup Deployments:

Backup machines for UAT and PROD are deployed and synchronized in parallel with the primary services. This ensures up-to-date backup machines are ready for disaster recovery scenarios.
3. Deployment Workflow
The deployment is automated through three Jenkins jobs, each designed to handle a specific aspect of the process:

Job 1: Deploy Services and Configurations:

This job deploys services and updates configurations across the servers (production and non-production). It ensures that the services are deployed according to the current configurations stored in Git repositories.
Job 2: Scheduled Service Deployment:

This job manages scheduled deployments, which can include maintenance windows or planned updates for critical services. It ensures configurations and services are deployed at predefined times with minimal disruption.
Job 3: Clone Scripts and Repositories:

This job handles cloning the necessary scripts and configurations from Git repositories to the appropriate machines. It ensures that the latest versions of scripts and deployment instructions are always in sync.
4. Key Features
Artifact Deployment from Nexus:

The process automates the deployment of artifacts from Nexus to different environments, ensuring consistency and version control across all environments.
Secrets Management:

Secrets are removed from deployment scripts and stored in HashiCorp Vault, ensuring secure access and limiting exposure of sensitive data.
Versioning:

The configurations for different environments and services are version-controlled in Git repositories, making it easier to track changes and roll back if necessary.
Parallel Deployments:

Both active and backup machines for UAT and Production environments are deployed and configured simultaneously to ensure synchronization and readiness for disaster recovery.
5. Goals and Benefits
Automate Deployment Processes:

Eliminate manual intervention in deployment processes, reduce human error, and streamline the deployment of services across environments.
Environment Synchronization:

Maintain consistent service versions and configurations across all environments (production, UAT, development) to avoid discrepancies and ensure smooth transitions.
Enhanced Security:

Secure communication between different components by moving sensitive data (like API keys and passwords) into Vault, reducing the risk of unauthorized access.
Disaster Recovery Readiness:

Ensure backup machines are always synchronized with active ones, allowing for immediate failover in the case of system failure or disaster recovery scenarios.
Improved Management:

Simplify the management of service deployments and configurations using user-friendly interfaces through Jenkins and Ansible.
