
#!/bin/bash

# ===== Configuration =====
SCAN_DIR="$HOME"                      # Répertoire à scanner
OUTPUT_FILE="local_secrets_report.txt"

# Liste de patterns à rechercher
SECRETS=("password" "secret" "SECRET_KEY" "api_key" "token" "passwd")

# Nettoyer ancien fichier
> "$OUTPUT_FILE"

echo "🔍 Scanning directory: $SCAN_DIR" 
echo "Results will be saved in: $OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# ===== Scanner les fichiers =====
for secret in "${SECRETS[@]}"; do
    echo "Checking for: $secret"
    matches=$(grep -r --exclude-dir=".git" --exclude="*.java" --exclude="*.groovy" -I -n -i "$secret" "$SCAN_DIR" 2>/dev/null)

    if [ ! -z "$matches" ]; then
        echo "Secret: $secret" >> "$OUTPUT_FILE"
        while IFS= read -r line; do
            file=$(echo "$line" | cut -d: -f1)
            value=$(echo "$line" | cut -d: -f2-)
            echo "  - File: $file" >> "$OUTPUT_FILE"
            echo "    Value: $value" >> "$OUTPUT_FILE"
        done <<< "$matches"
        echo "" >> "$OUTPUT_FILE"
    fi
done

# ===== Scanner les variables d'environnement =====
echo "🔍 Scanning environment variables..." 
echo "Environment Variables:" >> "$OUTPUT_FILE"

for secret in "${SECRETS[@]}"; do
    env_matches=$(env | grep -i "$secret")
    if [ ! -z "$env_matches" ]; then
        echo "Secret: $secret" >> "$OUTPUT_FILE"
        while IFS= read -r line; do
            var=$(echo "$line" | cut -d= -f1)
            val=$(echo "$line" | cut -d= -f2-)
            echo "  - Variable: $var" >> "$OUTPUT_FILE"
            echo "    Value: $val" >> "$OUTPUT_FILE"
        done <<< "$env_matches"
        echo "" >> "$OUTPUT_FILE"
    fi
done

echo "✅ Scan terminé. Résultats dans $OUTPUT_FILE"
