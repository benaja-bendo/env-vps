# Applications d'Exemple - `poc-env-traefik`

Ce dossier `/apps` contient plusieurs applications d'exemple configurées pour fonctionner avec Traefik en tant que reverse proxy. Ces exemples servent de démonstration pour un déploiement et un routage simplifiés à l'aide de Traefik.

## Liste des Applications

1. **Laravel App (Louka-Loca)**  
   Une application Laravel de démonstration configurée pour fonctionner avec Traefik. Elle permet de tester le routage, les certificats SSL et les configurations spécifiques à Laravel dans un environnement Docker.

2. **Node.js App (API avec Express)**  
   Une API de démonstration créée avec Node.js et Express, configurée pour fonctionner avec Traefik. Elle se connecte à une base de données PostgreSQL et à une base de données MongoDB, toutes deux installées sur le serveur VPS.

## Objectifs et Utilité

Ces applications permettent de :

- Tester les configurations de Traefik pour différents services.
- Vérifier le routage, la gestion des certificats et l'équilibrage de charge dans un environnement Docker.
- Expérimenter des modifications et observer leur impact en temps réel.

Chaque application inclut un fichier README spécifique pour expliquer comment la configurer et la lancer.

## Démarrage Global

1. **Lancer les applications** :

   ```bash
   cd /chemin/vers/app
   docker compose -f <nom_du_fichier_docker_production> up -d
   ```
