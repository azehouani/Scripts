# 🚀 Java Build and Deployment Pipeline (GitHub Actions)

This repository includes a **GitHub Actions pipeline** that automates the **build and deployment** of Java project artifacts across multiple environments.

---

## 🧩 Overview

The pipeline is designed to:

- Build and package Java projects.
- Push generated artifacts to **JFrog Artifactory**.
- Optionally deploy artifacts to target environments.

It supports three project types:
- **Library (`lib`)**
- **Module (`module`)**
- **Batch (`bash`)**

---

## ⚙️ Step 1: Input Parameters

When triggering the pipeline, the following parameters are required:

| Parameter | Description |
|------------|-------------|
| **Branch** | The Git branch to build. |
| **Option** | Defines the process to run:<br>• **Run CI Pipeline** → Runs only the CI process, generates and pushes artifacts to JFrog.<br>• **Release to Environment** → Deploys the latest artifacts built from the specified branch. |
| **Java Version** | Java version used to compile the project. |
| **Maven Version** | Maven version used to build the project. |

---

## 🏗️ Step 2: Pipeline Output

The pipeline builds and publishes three types of Java projects:

### 🔹 Library Projects (`lib`)
- Compiles and builds the library.
- Generates a `.jar` artifact and pushes it to **JFrog Artifactory**.
- Artifact naming convention:
  ```
  <version>-<branchName>-<commitHash>
  ```

---

### 🔹 Module and Batch Projects (`module`, `bash`)
- Compiles and builds the project.
- Pushes the generated `.jar` to JFrog.
- Creates a **ZIP package** of the application.
- ZIP naming convention:
  ```
  <version>-<branchName>-<commitHash>
  ```

---

## 🧠 Automatic Snapshot Versioning

All projects built by this pipeline — **library**, **module**, and **batch** — automatically generate **snapshot versions**.

- No need to manually specify `-SNAPSHOT` in your `pom.xml`.
- The pipeline automatically manages snapshot tagging and versioning for all artifacts.
- This ensures consistent and traceable artifact versions across all environments.

---

## 🔗 Dependency Management

When a **module** or **batch** project depends on a **library**:

- Update the dependency version in your `pom.xml` whenever a new library version is built.
- Use the **generated artifact version** from JFrog (e.g., `<version>-<branchName>-<commitHash>`).

**Example:**

```xml
<dependency>
  <groupId>com.example</groupId>
  <artifactId>my-library</artifactId>
  <version>1.2.0-featureX-a1b2c3d</version>
</dependency>
```

> 💡 Snapshot versions are automatically handled — no manual `-SNAPSHOT` updates are required.

---

## 📝 Notes

- Ensure consistent **Java** and **Maven** versions across all environments.
- Always verify artifact publication in **JFrog Artifactory** before deployment.
- Environment deployment steps depend on the selected option.

---

## 📄 License

This project follows the internal DevOps automation standards.  
Contact your DevOps team for support or configuration changes.
