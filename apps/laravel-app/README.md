# Louka-Loca (Example Laravel Application)

Cette application Laravel est un exemple de configuration pour fonctionner avec Traefik comme reverse proxy. Elle est incluse dans le dépôt `poc-env-traefik` pour démontrer comment adapter une application Laravel afin qu'elle s'intègre parfaitement avec l'environnement Traefik.

## Prérequis

1. **Cloner le dépôt**  
   Clonez le dépôt `poc-env-traefik` et accédez au dossier `apps/laravel-app` :

    ```bash
    git clone https://github.com/benaja-bendo/poc-env-traefik
    cd poc-env-traefik/apps/laravel-app
    ```

2. **Configuration de l'environnement**

    - Copiez le fichier `.env.example` vers `.env` :

    ```bash
    cp .env.example .env
    ```

    - Modifiez les paramètres nécessaires dans le fichier `.env` :
        - **Database** : Configurez les variables `DB_HOST`, `DB_PORT`, `DB_DATABASE`, `DB_USERNAME`, et `DB_PASSWORD` en fonction de votre configuration.
        - **Traefik** : Assurez-vous que le domaine `APP_URL` correspond à celui configuré dans Traefik pour cet exemple d'application Laravel.

3. **Lancer l'application**  
   Utilisez Docker Compose pour démarrer l'application :

    ```bash
    docker compose -f docker-compose.prod.yaml up --build -d
    ```

   L'application Laravel devrait maintenant être accessible via l'URL configurée dans Traefik.

## Commandes Utiles

- **Migration de la base de données** :

    ```bash
    docker compose exec <nom_du_conteneur> php artisan migrate
    ```

- **Récupération des logs** :

    ```bash
    docker compose logs -f
    ```

- **Arrêter les conteneurs** :

    ```bash
    docker compose down -v
    ```

## Points d'Attention

- **Certificat SSL** : Traefik est configuré pour gérer les certificats SSL. Veillez à ce que votre domaine ait un certificat valide ou ajoutez un certificat auto-signé pour un usage local.
- **Résolution de Domaine** : Si vous testez en local, modifiez votre fichier `/etc/hosts` pour faire correspondre `laravel-app.localhost` à l'IP du serveur où Traefik est en écoute.
