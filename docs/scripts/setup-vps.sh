#!/bin/bash

# Fonction pour désinstaller complètement Docker
desinstaller_docker() {
    echo "Arrêt des conteneurs Docker en cours d'exécution..."
    sudo docker ps -q | xargs -r sudo docker stop

    echo "Suppression de tous les conteneurs Docker..."
    sudo docker ps -a -q | xargs -r sudo docker rm

    echo "Suppression de toutes les images Docker..."
    sudo docker images -q | xargs -r sudo docker rmi -f

    echo "Suppression de tous les volumes Docker..."
    sudo docker volume ls -q | xargs -r sudo docker volume rm

    echo "Purge des paquets Docker..."
    sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    echo "Suppression des fichiers de configuration Docker..."
    sudo rm -rf /var/lib/docker /etc/docker
    sudo rm -rf /var/run/docker.sock
    sudo rm -rf /usr/local/bin/docker-compose

    echo "Suppression du groupe Docker..."
    sudo groupdel docker

    echo "Nettoyage des paquets inutilisés..."
    sudo apt-get autoremove -y
    sudo apt-get autoclean -y

    echo "Docker a été complètement désinstallé."
}

# Demander à l'utilisateur s'il souhaite désinstaller Docker
read -p "Souhaitez-vous désinstaller complètement Docker avant de procéder à une nouvelle installation ? (y/n) " reponse
if [[ "$reponse" =~ ^[YyOo]$ ]]; then
    desinstaller_docker
else
    echo "La désinstallation de Docker a été annulée."
fi

# Mettre à jour le système
echo "Mise à jour du système..."
sudo apt update && sudo apt upgrade -y

# Installer les dépendances nécessaires
echo "Installation des paquets requis..."
sudo apt install -y ca-certificates curl gnupg

# Ajouter la clé GPG officielle de Docker
echo "Ajout de la clé GPG officielle de Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.gpg > /dev/null

# Ajouter le dépôt Docker aux sources APT
echo "Ajout du dépôt Docker aux sources APT..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Mettre à jour la liste des paquets
echo "Mise à jour de la liste des paquets..."
sudo apt update

# Installer Docker Engine, CLI et plugins
echo "Installation de Docker Engine, CLI et plugins..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Créer le groupe Docker s'il n'existe pas
if ! getent group docker > /dev/null; then
    echo "Création du groupe Docker..."
    sudo groupadd docker
fi

# Ajouter l'utilisateur actuel au groupe Docker
echo "Ajout de l'utilisateur au groupe Docker..."
sudo usermod -aG docker $USER

# Appliquer les changements de groupe
echo "Application des changements de groupe..."
newgrp docker

# Vérification de l'installation de Docker et Docker Compose
echo "Vérification de l'installation de Docker et Docker Compose..."
docker --version
docker compose version
