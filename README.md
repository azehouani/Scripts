his Jenkins job is designed to automate the deployment and configuration of a service called Scheduled Service. It handles the following tasks:

Fetch Project: Updates scripts for the service from a Git repository.
Update Application Config File: Updates the application's properties file for each service.
Update Artifacts: Fetches the latest artifact (JAR) from Nexus and deploys it to the server.
Backup Server Synchronization: Ensures that both the main server and the backup server are synchronized after the deployment.



Job Steps
1. Fetch Project
Description: This step clones or pulls the latest updates for the ilc-scheduled-service project from the Git repository. It ensures that all required scripts on the server are up-to-date.

 Update Application Config File
Description: This step modifies the application's configuration file (application.properties) with the appropriate settings for the service. The configuration can be customized based on service-specific requirements.


3. Update Artifacts (Nexus)
Description: This step downloads the latest version of the required artifact (e.g., a JAR file) from the Nexus repository and deploys it to the server.

4. Backup Server Synchronization
Description: This step ensures that both the main server and the backup server are synchronized. It uses rsync to copy the updated files from the main server to the backup server.

Job Parameters
The job has configurable parameters that allow users to select specific services or options during job execution.

1. fetch_project (Boolean)
Description: Allows the user to choose whether to update scheduling scripts from the Git repository for the selected service.
Type: Boolean (Checkbox)
2. scheduled_branch (String)
Description: The name of the branch used for rebasing the scheduling scripts in the Git repository.
Type: String (Text input)
3. update_config (Boolean)
Description: Allows the user to update the application configuration file for the selected scheduled services.
Type: Boolean (Checkbox)
4. update_services (Boolean)
Description: Allows the user to update the selected scheduled service artifacts (JAR files) from Nexus.
Type: Boolean (Checkbox)
