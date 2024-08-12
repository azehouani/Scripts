Jenkins Job Documentation: ile-manage-services

Introduction
The Jenkins job ile-manage-services is designed to automate the process of deploying and managing services across different environments. The primary objective is to eliminate manual actions on various environments while maintaining stable, versioned releases of projects and artifacts (JARs). This job centralizes and automates the deployment, management, and configuration of services through a single interface with predefined steps.

Job Link
Job Name: ile-manage-services
Jenkins Link: www.jenkins.com/ilc-manage-services
Job Steps
Checkout
Description: This step retrieves the latest version of the Ansible project, which is used to manage the various services to be deployed and configured.
Setup Server
Description: This step configures the profile file associated with each environment, using the specified parameters. It prepares the target environment for deployment or service management.
Stop Services
Description: This step stops the services currently running in the selected environment.
Restart Services
Description: This step restarts the services that have been stopped or need a restart after updates or changes.
Deploy Services
Description: This step deploys new services or updates existing services in the selected environment, according to the provided parameters.
Job Parameters
Environment
Description: This parameter allows you to select the target environment for the process (e.g., dev, test, prod).
Option
Description: This parameter defines the operation to be applied from the following options:
Release: Deploys a new version of the service.
Stop: Stops the currently running services.
Restart: Restarts the services.
Update Profile File: Reconfigures or updates the environment profile file, using the settings defined in the Ansible playbooks.
Deploy All Services
Description: If selected, this option deploys all Java services and reporting services to the target environment.
IL Reporting Service
Description: Deploys the ile-reporting-service project. You can specify the branch you want to deploy via the node_branche parameter (default is the master branch).
Is Snapshot
Description: This parameter determines whether artifacts should be retrieved from the Nexus snapshot repository. If selected, artifacts are downloaded from the snapshot repository; otherwise, they are retrieved from the Release repository.
Java Service
Description: Allows you to select the name of the Java service to deploy and specify the version of the JAR to use. By default, the latest version is selected, which retrieves the most recent version available on Nexus.
Conclusion
The Jenkins job ile-manage-services is a powerful tool for automating the deployment and management processes for services across different environments. With its many configurable parameters, it offers great flexibility and ensures that services are deployed and managed consistently and efficiently.
