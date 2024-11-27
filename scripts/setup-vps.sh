#!/bin/bash

# Mettre à jour le système
echo "Mise à jour du système..."
sudo apt update && sudo apt upgrade -y

# Installer les dépendances nécessaires
echo "Installation des outils de base..."
sudo apt install -y git vim htop build-essential

# Ajouter l'utilisateur actuel au groupe Docker
echo "Ajout de l'utilisateur au groupe Docker..."
sudo usermod -aG docker $USER

# Appliquer les changements de groupe sans déconnexion
newgrp docker

# Vérification de l'installation de Docker et Docker Compose
echo "Vérification de l'installation de Docker et Docker Compose..."
docker --version
docker compose version


# Vérification de Docker et Docker Compose
echo "Vérification de Docker et Docker Compose..."



