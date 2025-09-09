#!/bin/bash

# ===== Configuration =====
BASE_GIT_URL="https://github.com/your-org"  # Change to your base URL
PROJECTS_FILE="projects.txt"                # File containing project names (one per line)
OUTPUT_FILE="secrets_report.txt"

# List of secret patterns to search for
SECRETS=("password" "secret" "SECRET_KEY" "api_key" "token" "passwd")

# Clean previous output
> "$OUTPUT_FILE"

# Read project names and clone
while IFS= read -r project; do
    echo "Processing project: $project"
    
    # Clone the project if it does not exist
    if [ ! -d "$project" ]; then
        git clone "$BASE_GIT_URL/$project.git" || { echo "Failed to clone $project"; continue; }
    fi

    echo "Projectname: $project" >> "$OUTPUT_FILE"
    echo "Path: $(pwd)/$project" >> "$OUTPUT_FILE"

    # Scan for secrets
    while IFS= read -r secret; do
        # Search for secret in all files recursively
        matches=$(grep -r --exclude-dir=".git" -i "$secret" "$project")
        if [ ! -z "$matches" ]; then
            echo "   - secret: $secret" >> "$OUTPUT_FILE"
            while IFS= read -r line; do
                file=$(echo "$line" | cut -d: -f1)
                value=$(echo "$line" | cut -d: -f2-)
                echo "     - value: $value (file: $file)" >> "$OUTPUT_FILE"
            done <<< "$matches"
        fi
    done <<< "$(printf "%s\n" "${SECRETS[@]}")"

    echo "" >> "$OUTPUT_FILE"

done < "$PROJECTS_FILE"

echo "Scan completed! Check the results in $OUTPUT_FILE"
