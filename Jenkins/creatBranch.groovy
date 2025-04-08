pipeline {
    agent any

    parameters {
        string(name: 'PROJECTS', description: 'Comma-separated list of GitHub repo names (e.g. repo1,repo2)')
        string(name: 'BRANCH_NAME', description: 'Name of the new branch to create')
        string(name: 'BRANCH_SOURCE', description: 'Name of the source branch to branch from')
    }

    environment {
        GIT_CREDENTIALS_ID = 'your-git-credentials-id' // Replace with your Jenkins Git credentials ID
        GITHUB_ORG = 'your-github-org' // Replace with your GitHub org or user name
    }

    stages {
        stage('Create Release Branches') {
            steps {
                script {
                    def projectList = params.PROJECTS.tokenize(',')

                    projectList.each { repo ->
                        dir(repo.trim()) {
                            echo "Cloning ${repo}..."
                            git branch: params.BRANCH_SOURCE,
                                url: "git@github.com:${env.GITHUB_ORG}/${repo}.git",
                                credentialsId: env.GIT_CREDENTIALS_ID

                            echo "Creating new branch ${params.BRANCH_NAME} from ${params.BRANCH_SOURCE}..."
                            sh """
                                git checkout -b ${params.BRANCH_NAME}
                                git push origin ${params.BRANCH_NAME}
                            """
                        }
                    }
                }
            }
        }
    }
}
