#!/bin/bash

# Exit on error
set -e

echo "=== Mise à jour des paquets ==="
sudo apt-get update
sudo apt-get upgrade -y

echo "=== Installation des dépendances nécessaires ==="
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

echo "=== Ajout de la clé GPG officielle de Docker ==="
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "=== Ajout du dépôt Docker dans APT sources ==="
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "=== Mise à jour des paquets après ajout du dépôt Docker ==="
sudo apt-get update

echo "=== Installation de Docker Engine, CLI et containerd ==="
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "=== Vérification de l'installation ==="
sudo docker --version

echo "=== Ajout de l'utilisateur courant au groupe docker ==="
sudo usermod -aG docker $USER

echo "=== Changement de propriétaire du socket Docker ==="
sudo chown $USER /var/run/docker.sock

echo "=== Installation terminée ! ==="
echo "Déconnectez-vous et reconnectez-vous pour que les modifications prennent effet, ou exécutez 'newgrp docker' pour appliquer les changements immédiatement."
