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




Git Workflow for Large Multi-Project Application

Branching Strategy
	1.	Main Branches
	•	main (or master): Stable, production-ready code. Only updated through releases.
	•	develop: Integration branch where all features are merged before a release.
	2.	Feature & Bugfix Branches
	•	Feature branches: Created from develop. (feature/XYZ-123-new-api)
	•	Bugfix branches: Created from develop (for pre-release fixes) or main (for hotfixes).
	3.	Release Branches
	•	Created each week for new releases: release/1.3.4
	•	Once tested and approved, merged into main and develop.
	4.	Hotfix Branches
	•	For urgent production fixes: hotfix/1.3.4.1
	•	Merged into both main and develop.


Release Process
	1.	During the Week (Development Phase)
	•	Developers work on feature branches (feature/xyz-feature).
	•	Merge into develop via Pull Requests (PRs).
	•	CI/CD runs tests before merging.
	2.	Mid-Week (Feature Freeze)
	•	Identify projects that will be included in the upcoming release.
	•	Create a release branch from develop (release/1.3.4).
	3.	End of the Week (Testing & Release)
	•	QA team tests the release/1.3.4 branch.
	•	Fixes are applied directly to the release branch.
	•	Once stable, merge release/1.3.4 into main and tag it (v1.3.4).
	•	Merge release/1.3.4 back into develop.
	4.	Next Cycle Begins
	•	Developers continue working on new features in develop.
	•	The next release is planned (e.g., release/1.3.5).


Hotfix
	•	An issue is detected in production, and a Hotfix branch (pink) is created from main.
	•	Once the fix is applied, the hotfix branch is merged back into main and Release 1.0.0 to keep everything in sync.
	3.	Feature Merging
	•	Feature 1 is completed and merged into Release 1.0.0.
	•	After validation, Release 1.0.0 is merged into main.
	4.	Parallel Release Development
	•	While Release 1.0.0 is being tested, Release 2.0.0 (red) is created from main for another version.
	•	A new Feature 2 branch (yellow) is created from Release 2.0.0 for additional development.
	5.	Merging and Updating
	•	Feature 2 is merged into Release 2.0.0.
	•	Before merging Release 2.0.0 into main, it is rebased with main to include changes from Release 1.0.0.
	•	After successful testing, Release 2.0.0 is merged into main.

Conclusion

This workflow allows:
	•	Parallel releases without blocking development.
	•	Integration of urgent hotfixes while ensuring they propagate to the necessary branches.
	•	Ensuring each release includes the latest updates from main before being merged.
 
