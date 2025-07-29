import os
import shutil
import glob
import subprocess

def build_project(project_type, jar_name, project_name):
    if project_type == "batch":
        subprocess.run(["mvn", "clean", "assembly:single", "-Dmaven.test.skip=true"], check=True)

    elif project_type == "lib":
        subprocess.run(["mvn", "clean", "install", "-DskipTests=true"], check=True)

    elif project_type == "api":
        subprocess.run(["mvn", "clean", "install", "-DskipTests=true"], check=True)
        assembly_api_project(jar_name, project_name)

def get_project_type(repo_name):
    try:
        result = subprocess.run(
            ["mvn", "help:effective-pom"],
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            text=True
        )
        if "treso_assembly" in result.stdout:
            return "batch"
    except Exception as e:
        print(f"Failed to run Maven command: {e}")

    if "-libs-" in repo_name or "-lib-" in repo_name:
        return "lib"

    return "api"

def assembly_api_project(jar_name, project_name):
    zip_name = f"{jar_name}-dist.zip"

    # Create all required directories
    dirs_to_create = [
        f"{project_name}/conf",
        f"{project_name}/tmp/final",
        f"{project_name}/data",
        f"{project_name}/log",
        f"{project_name}/bin"
    ]
    for d in dirs_to_create:
        os.makedirs(d, exist_ok=True)

    # Write jar name to file
    with open("bin/jar_name.txt", "w") as f:
        f.write(f"{jar_name}.jar\n")

    # Copy resource files to conf
    resource_patterns = ["*.yml", "*.xml", "*.properties"]
    for pattern in resource_patterns:
        for file in glob.glob(f"src/main/resources/{pattern}"):
            shutil.copy(file, f"{project_name}/conf/")

    # Copy final JAR
    jar_path = f"target/{jar_name}.jar"
    if os.path.exists(jar_path):
        shutil.copy(jar_path, f"{project_name}/")
    else:
        raise FileNotFoundError(f"JAR file not found: {jar_path}")

    # Create ZIP archive (including project folder itself)
    shutil.make_archive(zip_name.replace(".zip", ""), 'zip', root_dir='.', base_dir=project_name)

def main():
    repo_name = "java-SRG-modules-bir_envcpa"
    project_name = "bir_envcpa"
    jar_name = "bir_envcpa-2.1.2-SNAPSHOT"

    project_type = get_project_type(repo_name)
    print(f"Detected project type: {project_type}")
    build_project(project_type, jar_name, project_name)

if __name__ == "__main__":
    main()
