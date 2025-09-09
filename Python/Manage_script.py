import json
import subprocess
import sys
from pathlib import Path

def deploy_project(json_path, deploy_script, project_name, action):
    # Load JSON
    with open(json_path, "r") as f:
        projects = json.load(f)

    # Check if project exists in JSON
    if project_name not in projects:
        print(f"❌ Project '{project_name}' not found in {json_path}")
        sys.exit(1)  # exit with error
    
    values = projects[project_name]

    if not values:  # Empty list
        print(f"NO AUTOSTS PROCESS TO STOP FOR {project_name}")
    else:
        for value in values:
            print(f"Executing: {deploy_script} {action} {value}")
            subprocess.run([str(deploy_script), action, value], check=True)

if __name__ == "__main__":
    if len(sys.argv) != 5:
        print("Usage: python deploy.py <json_path> <deploy_script> <project_name> <status|stop|start>")
        sys.exit(1)

    json_path = Path(sys.argv[1])
    deploy_script = Path(sys.argv[2])
    project_name = sys.argv[3]
    action = sys.argv[4]

    if action not in ["status", "stop", "start"]:
        print("❌ Action must be one of: status | stop | start")
        sys.exit(1)

    deploy_project(json_path, deploy_script, project_name, action)
