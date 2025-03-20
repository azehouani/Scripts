#!/bin/bash

# Configuration
GIT_BASE_URL="git@github.com:your-org"  # Change to your Git organization or base URL
PROJECT_LIST="projects.txt"  # File containing project names

# Check if the project list file exists
if [[ ! -f "$PROJECT_LIST" ]]; then
    echo "Error: File '$PROJECT_LIST' not found!"
    exit 1
fi

# Read each project name from the file
while IFS= read -r PROJECT; do
    [[ -z "$PROJECT" ]] && continue  # Skip empty lines

    echo "Processing project: $PROJECT"

    # Clone the project
    if [[ -d "$PROJECT" ]]; then
        echo "Repository '$PROJECT' already exists locally, skipping clone."
        cd "$PROJECT" || exit 1
    else
        git clone "$GIT_BASE_URL/$PROJECT.git" || { echo "Failed to clone $PROJECT"; continue; }
        cd "$PROJECT" || exit 1
    fi

    # Fetch all branches
    git fetch --all

    # Check if main branch exists
    if git rev-parse --verify main >/dev/null 2>&1; then
        echo "Branch 'main' already exists in $PROJECT."
    else
        echo "Creating 'main' branch..."

        # Check if master exists
        if git rev-parse --verify origin/master >/dev/null 2>&1; then
            git checkout -b main origin/master
        elif git rev-parse --verify origin/develop >/dev/null 2>&1; then
            git checkout -b main origin/develop
        else
            echo "Neither 'master' nor 'develop' exists. Skipping $PROJECT."
            cd ..
            continue
        fi

        # Push the new main branch
        git push -u origin main
        echo "Branch 'main' created and pushed successfully!"
    fi

    cd ..  # Return to parent directory

done < "$PROJECT_LIST"

echo "All projects processed."
