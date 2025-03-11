#!/bin/bash

# Couleurs pour l'affichage
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Définition du répertoire de travail
NODE_DIR="$HOME/node"
CERT_DIR="$NODE_DIR/cert"
CERT_FILE="$CERT_DIR/cert.key"

# Fonction pour afficher un message d'erreur et quitter
function error_exit {
    echo -e "${RED}[Erreur] $1${NC}"
    exit 1
}

# Affichage du menu
echo "Choisissez une option :"
echo "1) Restart"
echo "2) Build"
read -p "Entrez votre choix (1 ou 2) : " choice

# Vérification de l'entrée utilisateur
if [[ "$choice" != "1" && "$choice" != "2" ]]; then
    error_exit "Choix invalide."
fi

# Demander l'environnement
read -p "Entrez l'environnement (ex: dev, staging, prod) : " ENV
if [[ -z "$ENV" ]]; then
    error_exit "L'environnement ne peut pas être vide."
fi

# Aller dans le répertoire
cd "$NODE_DIR" || error_exit "Impossible d'accéder à $NODE_DIR"

# Assurer que le dossier cert existe
mkdir -p "$CERT_DIR"

# Récupérer la valeur du certificat via get-cert.py
echo -e "${GREEN}Récupération du certificat...${NC}"
CERT_VALUE=$(python3 get-cert.py)

# Vérifier si la commande a réussi
if [[ $? -ne 0 || -z "$CERT_VALUE" ]]; then
    error_exit "Erreur lors de la récupération du certificat."
fi

# Écrire la valeur dans cert.key
echo "$CERT_VALUE" > "$CERT_FILE"
echo -e "${GREEN}Certificat enregistré dans $CERT_FILE${NC}"

# Exécuter les commandes selon le choix de l'utilisateur
if [[ "$choice" == "1" ]]; then
    echo -e "${GREEN}Redémarrage du service...${NC}"
    npm run pm2 delete ilc-reporting-service
    npm run start:"$ENV"
elif [[ "$choice" == "2" ]]; then
    echo -e "${GREEN}Build du service...${NC}"
    npm run pm2 delete ilc-reporting-service
    rm -rf node_modules local-chromium
    npm install
    chmod -R 777 node_modules/.bin/
    npm run build
    npm run start:"$ENV"
fi

echo -e "${GREEN}Opération terminée avec succès.${NC}"
