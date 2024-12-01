#!/bin/bash

# Vérifie si Docker est installé
if ! command -v docker &> /dev/null
then
    echo "Erreur : Docker n'est pas installé. Veuillez l'installer avant d'exécuter ce script."
    exit 1
fi

# Vérifie si Docker Compose est installé
if ! command -v docker compose &> /dev/null
then
    echo "Erreur : Docker Compose n'est pas installé. Veuillez l'installer avant d'exécuter ce script."
    exit 1
fi

# Chemin vers le dossier 'databases'
DATABASES_DIR="../databases"

# Vérifie si le dossier 'databases' existe
if [ ! -d "$DATABASES_DIR" ]; then
    echo "Erreur : Le dossier 'databases' n'existe pas dans le répertoire courant."
    exit 1
fi

# Parcourt les sous-dossiers du dossier 'databases'
echo "Lancement des conteneurs Docker dans le dossier 'databases'..."

for COMPOSE_FILE in $(find "$DATABASES_DIR" -name "docker-compose.yaml"); do
    DIR=$(dirname "$COMPOSE_FILE")
    echo "Lancement de Docker Compose dans : $DIR"
    
    # Se déplace dans le dossier et lance `docker compose up`
    (
        cd "$DIR" || exit
        docker compose up -d
        if [ $? -eq 0 ]; then
            echo "Conteneurs démarrés avec succès dans $DIR."
        else
            echo "Erreur lors du démarrage des conteneurs dans $DIR."
        fi
    )
done

echo "Tous les conteneurs de bases de données ont été lancés."
