Job Purpose
This Jenkins job automates the process of cloning projects from GitHub repositories to various environments. It eliminates the need for manual modifications on servers, ensures that deployed scripts are in sync with the Git repositories, and maintains version control of the source files. This is particularly useful for environments such as User Acceptance Testing (UAT) and Production (PROD).

Job Steps
1. Clone Repositories
Purpose: Clone the specified project to the selected environment.
Functionality: This step pulls the latest version of the project from GitHub based on the specified branch. It ensures that the environment has the most recent updates from the repository, maintaining consistency and version control.
Usage: Essential for synchronizing the deployed scripts in various environments.
2. Clone Repository to Backup Server
Purpose: Clone the same version of the project to the backup server for UAT and PROD environments.
Functionality: This step ensures that the backup server mirrors the changes made in the primary environment. By cloning the same version of the project, it helps in maintaining redundancy and ensures that both environments are synchronized.
Usage: Critical for ensuring that the backup environment is ready for failover or testing scenarios.
Job Parameters
Clone Autosys: This option allows the user to clone and update Autosys scripts deployed on the server from the ilc-autosys project on GitHub. When selected, it triggers the cloning process for the Autosys-related files.

autosys_branch: This parameter specifies the branch of the ilc-autosys repository to clone or rebase with. It allows users to choose the appropriate version or environment for the Autosys scripts.

Clone Script: This option enables the cloning and updating of the script folder deployed on the server from the ilc-script project on GitHub. It ensures that the latest scripts are always available on the server.

script_branch: This parameter indicates the branch of the ilc-script repository that the job should clone or rebase with. This provides flexibility in selecting the correct version of the scripts.

This Jenkins job streamlines the cloning process, reducing the risk of manual errors and ensuring that all environments are consistently updated with the latest versions from the Git repositories. This enhances operational efficiency and helps maintain high availability in case of server failures.
