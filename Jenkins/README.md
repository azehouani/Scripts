# Jenkins Pipeline - Release Branch Creator

This Jenkins pipeline is designed to **automate the creation of release branches** across a list of GitHub projects targeted for a specific release.

## Purpose

This job enables:
- Creating a new release branch from a given source branch (`main`, `develop`, etc.)
- Reusing an existing branch if it already exists, updating it with the latest changes from the source branch
- Applying the process to multiple repositories in one execution
- Automatically cleaning workspaces before and after the job to avoid leftovers

---

## Parameters

| Parameter        | Description                                                                 |
|------------------|-----------------------------------------------------------------------------|
| `PROJECTS`       | Comma-separated list of GitHub repository names (e.g. `repo1,repo2`)        |
| `BRANCH_NAME`    | Name of the release branch to create or update (e.g. `release-1.2.0`)       |
| `BRANCH_SOURCE`  | Name of the source branch to branch from (e.g. `main`)                      |

---

## How It Works

For each project in the list:

1. The repository is cloned from GitHub.
2. The job checks if the target branch `BRANCH_NAME` already exists:
   - **If it exists**: the branch is updated with the latest changes from `BRANCH_SOURCE`.
   - **If it does not exist**: the job creates a new branch from `BRANCH_SOURCE` and pushes it to GitHub.
3. The Jenkins workspace is cleaned between each repository to ensure isolation.

---

## Post Actions

At the end of the job, the workspace is always cleaned — regardless of whether the build was successful or failed — to ensure a clean environment for the next run.

---

## Requirements

- A Jenkins credential (type: **"Username with password"**) that includes a GitHub username and a Personal Access Token (PAT), used to authenticate Git operations.
- All repositories should belong to the same GitHub organization (defined via `GITHUB_ORG` in the pipeline).

---

## Example Execution

```text
PROJECTS = repo-client,repo-backend,repo-shared
BRANCH_NAME = release-1.2.0
BRANCH_SOURCE = main
