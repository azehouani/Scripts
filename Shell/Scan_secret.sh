#!/usr/bin/env bash
# home_audit.sh
# Audit simple non-exfiltrant limité au $HOME
# Liste chemins/métadonnées susceptibles de contenir des secrets (ne lit pas les fichiers).

set -euo pipefail

TS="$(date +%Y%m%d-%H%M%S)"
REPORT="$HOME/home_secret_audit_${TS}.txt"

echo "Audit local (home) non-exfiltrant - $TS" > "$REPORT"
echo "Utilisateur: $(whoami) | Hôte: $(hostname)" >> "$REPORT"
echo "NOTE: Ce rapport liste chemins/métadonnées. Il NE CONTIENT PAS de secrets en clair." >> "$REPORT"
echo "----" >> "$REPORT"

section() { echo -e "\n## $1\n" >> "$REPORT"; }

# 1) Fichiers suspects dans $HOME
section "Fichiers suspects (.env, *.key, *.pem, *.crt, id_rsa...)"
find "$HOME" -type f \( \
  -iname ".env" -o -iname "*.env" -o -iname "*.key" -o -iname "*.pem" -o -iname "*.crt" -o -iname "*.cer" -o -iname "id_rsa" -o -iname "id_dsa" -o -iname "authorized_keys" \
\) 2>/dev/null | sed 's/^/  /' >> "$REPORT" || true

# 2) Fichiers world-readable / world-writable (top 100) dans $HOME
section "Fichiers world-readable (top 100) dans $HOME"
find "$HOME" -type f -perm -o+r -printf "  %p\t%M\t%u:%g\n" 2>/dev/null | head -n 100 >> "$REPORT" || true

section "Fichiers world-writable (top 100) dans $HOME"
find "$HOME" -type f -perm -o+w -printf "  %p\t%M\t%u:%g\n" 2>/dev/null | head -n 100 >> "$REPORT" || true

# 3) Noms de variables d'environnement (sans valeurs)
section "Variables d'environnement (NOMS seulement)"
printenv 2>/dev/null | awk -F= '{print $1}' | sort -u | sed 's/^/  /' >> "$REPORT" || true

section "Variables d'environnement (noms contenant PASS/SECRET/TOKEN/KEY/AWS/DB)"
printenv 2>/dev/null | awk -F= '{print $1}' | grep -Ei "pass|pwd|password|secret|token|key|aws|db|mysql|pg|credential|cert|private" | sort -u | sed 's/^/  /' >> "$REPORT" || echo "  (Aucune variable au nom sensible détectée ou shell restreint.)" >> "$REPORT"

# 4) Dépôts Git locaux (racines) dans $HOME
section "Dépôts Git locaux (racines) dans $HOME"
find "$HOME" -type d -name ".git" 2>/dev/null | sed 's/\/.git$//' | sed 's/^/  /' | sort -u >> "$REPORT" || true

# 5) Fichiers modifiés récemment (30 jours) — $HOME (top 100)
section "Fichiers modifiés dans les 30 derniers jours (top 100) dans $HOME"
find "$HOME" -type f -mtime -30 -printf "  %T@ %p %M %u:%g\n" 2>/dev/null | sort -nr | head -n 100 >> "$REPORT" || true

# 6) Projets Node.js (package.json) dans $HOME
section "Projets Node.js (package.json) dans $HOME"
find "$HOME" -type f -name "package.json" 2>/dev/null | sed 's/\/package.json$//' | sed 's/^/  /' | head -n 200 >> "$REPORT" || true

# 7) Résumé & recommandations rapides
section "Résumé & recommandations rapides"
cat <<EOF >> "$REPORT"
- Inspecter localement (en privé) les chemins listés ci-dessus.
- Pour chaque secret trouvé: révoquer/rotater, puis stocker dans un gestionnaire de secrets (Vault, AWS Secrets Manager...).
- Restreindre permissions (ex: chmod 600 pour clés privées).
- Ajouter des hooks Git / gitleaks dans CI pour prévenir l'ajout de secrets dans les repos.
- Ne pas partager le contenu de ces fichiers dans des canaux non sécurisés.
EOF

echo "Audit terminé. Rapport: $REPORT"
echo "Le script NE montre PAS de contenus sensibles. Ouvre le rapport localement (less, vim) pour l'examiner."
