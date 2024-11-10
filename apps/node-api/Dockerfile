# Utiliser une image Node.js légère
FROM node:18-alpine

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers nécessaires
COPY package*.json ./
RUN npm install

COPY . .

# Exposer le port de l'API
EXPOSE 3000

# Commande de démarrage de l'application
CMD ["npm", "start"]
