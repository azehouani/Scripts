#!/bin/bash

BRANCH_NAME="release-1.3.5"
WORKFLOW_FILE="main.yaml"
REPOS_FILE="repos.txt"
OUTPUT_FILE="output.txt"

# Clear or create output file
echo "Generated project links:" > "$OUTPUT_FILE"

while read -r repo; do
  echo "Processing $repo..."

  # Extract repo name (after slash)
  repo_name=$(basename "$repo")

  # Clone the repo
  git clone "https://github.com/$repo.git"
  cd "$repo_name" || continue

  # Create and checkout new branch
  git checkout -b "$BRANCH_NAME"

  # Remove existing GitHub Actions workflows
  rm -rf .github/workflows/*
  mkdir -p .github/workflows
  cp "../$WORKFLOW_FILE" .github/workflows/main.yaml

  # Commit and push
  git add .github/workflows/main.yaml
  git commit -m "Set up new GitHub Actions workflow for $BRANCH_NAME"
  git push -u origin "$BRANCH_NAME"

  # Change default branch via gh
  gh repo edit "$repo" --default-branch "$BRANCH_NAME"

  # Add repo link to output file
  echo "$repo_name : https://github.com/$repo" >> "../$OUTPUT_FILE"

  # Cleanup
  cd ..
  rm -rf "$repo_name"

  echo "✅ Finished $repo"
  echo "-----------------------------"
done < "$REPOS_FILE"
