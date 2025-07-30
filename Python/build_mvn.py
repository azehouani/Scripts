import os
import shutil
import glob
import subprocess

def build_project(project_type, jar_name, project_name):
    print(f"\n🔧 Building project type: {project_type}...")
    match project_type:
        case "batch":
            print("🚀 Running Maven with assembly:single...")
            subprocess.run("mvn clean assembly:single -Dmaven.test.skip=true", shell=True, check=True)

        case "lib":
            print("📦 Running Maven install (library)...")
            subprocess.run("mvn clean install -DskipTests=true", shell=True, check=True)

        case "api":
            print("🌐 Running Maven install (API)...")
            subprocess.run("mvn clean install -DskipTests=true", shell=True, check=True)
            assembly_api_project(jar_name, project_name)

        case _:
            raise ValueError(f"❌ Unknown project type: {project_type}")

def get_project_type(repo_name):
    print(f"\n🔍 Detecting project type from effective POM...")
    try:
        result = subprocess.run(
            "mvn help:effective-pom",
            shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            text=True
        )
        if "treso_assembly" in result.stdout:
            print("📘 Detected: batch project (contains 'treso_assembly')")
            return "batch"
    except Exception as e:
        print(f"⚠️ Failed to run Maven command: {e}")

    if "-libs-" in repo_name or "-lib-" in repo_name:
        print("📘 Detected: lib project (by name pattern)")
        return "lib"

    print("📘 Defaulting to: api project")
    return "api"

def assembly_api_project(jar_name, project_name):
    print(f"\n📦 Assembling API project: {project_name}...")

    zip_name = f"{jar_name}-dist.zip"

    # Step 1: Create directories
    print("📁 Creating directory structure...")
    dirs_to_create = [
        f"{project_name}/conf",
        f"{project_name}/tmp/final",
        f"{project_name}/data",
        f"{project_name}/log",
        f"{project_name}/bin"
    ]
    for d in dirs_to_create:
        os.makedirs(d, exist_ok=True)

    # Step 2: Write JAR name
    print("📝 Writing jar_name.txt...")
    os.makedirs("bin", exist_ok=True)
    with open("bin/jar_name.txt", "w") as f:
        f.write(f"{jar_name}.jar\n")

    # Step 3: Copy bin content
    print("📤 Copying files from bin/ to project/bin/...")
    for file in glob.glob("bin/*"):
        if os.path.isfile(file):
            shutil.copy(file, f"{project_name}/bin/")

    # Step 4: Copy resources
    print("📤 Copying resource files to conf/...")
    resource_patterns = ["*.yml", "*.xml", "*.properties"]
    for pattern in resource_patterns:
        for file in glob.glob(f"src/main/resources/{pattern}"):
            shutil.copy(file, f"{project_name}/conf/")

    # Step 5: Copy JAR
    print("📤 Copying final JAR...")
    jar_path = f"target/{jar_name}.jar"
    if os.path.exists(jar_path):
        shutil.copy(jar_path, f"{project_name}/")
    else:
        raise FileNotFoundError(f"❌ JAR file not found: {jar_path}")

    # Step 6: Create ZIP archive
    print(f"📦 Creating ZIP archive: {zip_name}")
    shutil.make_archive(zip_name.replace(".zip", ""), 'zip', root_dir='.', base_dir=project_name)

    print(f"✅ Done: created {zip_name}")

def main():
    repo_name = "java-SRG-modules-bir_envcpa"
    project_name = "bir_envcpa"
    jar_name = "bir_envcpa-2.1.2-SNAPSHOT"

    print("🚀 Starting build process...")
    project_type = get_project_type(repo_name)
    build_project(project_type, jar_name, project_name)
    print("🎉 Build process complete.")

if __name__ == "__main__":
    main()
    
