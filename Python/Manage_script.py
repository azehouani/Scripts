import json
import subprocess
import sys
from pathlib import Path

# === Configuration ===
JSON_PATH = Path("projects.json")   # path to your JSON file
DEPLOY_SCRIPT = Path("./deploy.sh") # path to your deploy.sh script
# =====================

def deploy_project(action, project_name):
    # Load JSON
    with open(JSON_PATH, "r") as f:
        projects = json.load(f)

    # Check if project exists in JSON
    if project_name not in projects:
        print(f"❌ Project '{project_name}' not found in {JSON_PATH}")
        sys.exit(1)  # exit with error
    
    values = projects[project_name]

    if not values:  # Empty list
        print(f"NO AUTOSTS PROCESS TO STOP FOR {project_name}")
    else:
        for value in values:
            print(f"Executing: {DEPLOY_SCRIPT} {action} {value}")
            subprocess.run([str(DEPLOY_SCRIPT), action, value], check=True)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python deploy.py <status|stop|start> <project_name>")
        sys.exit(1)

    action = sys.argv[1]
    project_name = sys.argv[2]

    if action not in ["status", "stop", "start"]:
        print("❌ Action must be one of: status | stop | start")
        sys.exit(1)

    deploy_project(action, project_name)
