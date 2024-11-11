# poc-env-traefik

Ce dépôt propose un exemple d'environnement pour déployer Traefik sur un VPS, avec des services tels que PostgreSQL et MongoDB.

## Prérequis

- `Docker` : Assurez-vous que Docker est installé sur votre machine.
- `Docker Compose` : Vérifiez que Docker Compose est également installé.

## Structure du projet

- `traefik/` : Contient la configuration de Traefik.
- `apps/` : Dossiers pour les applications et services Docker.
- `network/` : Fichiers relatifs à la configuration réseau.
- `monitoring/` : Configuration pour la surveillance des services.
- `logs/` : Répertoire pour les fichiers journaux.
- `scripts/` : Scripts utilitaires pour faciliter les opérations.

## Configuration de Traefik

Le fichier `traefik.yml` définit les paramètres de Traefik, notamment :

- Entrées : Ports et protocoles écoutés par Traefik.
- Fournisseurs : Configuration pour Docker en tant que fournisseur.
- Tableau de bord : Activation du tableau de bord pour la surveillance.

Assurez-vous que le fichier `traefik.yml` est correctement configuré avant de lancer les services.

## Déploiement des services

1. Réseau Docker : Créez un réseau Docker nommé traefik_network si ce n'est pas déjà fait :

   ```bash
   docker network create traefik_network
   ```

2. Traefik : Démarrez le service Traefik :

   ```bash
   cd traefik
   docker-compose up -d
   ```

3. Services : Démarrez les services souhaités (par exemple, PostgreSQL et MongoDB) :

   ```bash
   cd ../apps/postgres
   docker-compose up -d

   cd ../mongo
   docker-compose up -d
   ```

## Accès aux services

- PostgreSQL : Accessible via le port 5432.
- MongoDB : Accessible via le port 27017.

Assurez-vous que les ports correspondants sont ouverts et que les règles de pare-feu permettent l'accès.

## Surveillance

Le tableau de bord de Traefik est activé et accessible via le port 8080.
Pour y accéder :

```bash
http://<votre_ip>:8080
```

Remplacez `<votre_ip>` par l'adresse IP de votre VPS.

## Remarques

- Sécurité : Pensez à sécuriser l'accès au tableau de bord de Traefik en production.
- Certificats SSL : Pour une utilisation en production, configurez Let's Encrypt ou un autre fournisseur de certificats SSL.
- Personnalisation : Adaptez les configurations selon vos besoins spécifiques.

Pour plus d'informations, consultez la [Documentation officielle de Traefik](https://doc.traefik.io/traefik/).
