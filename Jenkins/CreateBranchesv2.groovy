pipeline {
    agent any

    parameters {
        string(name: 'PROJECTS', description: 'Comma-separated list of GitHub repo names (e.g. repo1,repo2)')
        string(name: 'BRANCH_NAME', description: 'Name of the new branch to create or update')
        string(name: 'BRANCH_SOURCE', description: 'Name of the source branch to branch from')
    }

    environment {
        GIT_CREDENTIALS_ID = 'your-git-credentials-id'  // Jenkins credentials ID (HTTPS or SSH)
        GITHUB_ORG = 'your-github-org'                  // GitHub organization or username
    }

    stages {
        stage('Process Projects') {
            steps {
                script {
                    def projectList = params.PROJECTS.tokenize(',')

                    projectList.each { repoName ->
                        processRepo(repoName.trim(), params.BRANCH_SOURCE, params.BRANCH_NAME)
                    }
                }
            }
        }
    }
}

// =========================
// Helper Methods
// =========================

def processRepo(String repo, String sourceBranch, String targetBranch) {
    dir(repo) {
        cleanWs()

        cloneRepo(repo, sourceBranch)

        if (remoteBranchExists(targetBranch)) {
            echo "[${repo}] Branch '${targetBranch}' already exists. Merging from '${sourceBranch}'..."
            updateBranch(targetBranch, sourceBranch)
        } else {
            echo "[${repo}] Creating new branch '${targetBranch}' from '${sourceBranch}'..."
            createBranch(targetBranch, sourceBranch)
        }

        cleanWs()
    }
}

def cloneRepo(String repo, String branch) {
    git branch: branch,
        url: "https://github.com/${env.GITHUB_ORG}/${repo}.git",
        credentialsId: env.GIT_CREDENTIALS_ID
}

def remoteBranchExists(String branchName) {
    return sh(
        script: "git ls-remote --exit-code --heads origin ${branchName}",
        returnStatus: true
    ) == 0
}

def createBranch(String newBranch, String sourceBranch) {
    sh """
        git checkout -b ${newBranch} origin/${sourceBranch}
        git push origin ${newBranch}
    """
}

def updateBranch(String branch, String sourceBranch) {
    sh """
        git fetch origin ${branch}
        git checkout ${branch}
        git merge origin/${sourceBranch} || true
        git push origin ${branch}
    """
}
