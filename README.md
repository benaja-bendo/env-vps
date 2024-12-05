# env-vps

Ce dépôt propose un exemple d'environnement pour déployer Traefik sur un VPS, avec des services tels que PostgreSQL et MongoDB.

## Prérequis

- `Docker` : Assurez-vous que Docker est installé sur votre machine.
- `Docker Compose` : Vérifiez que Docker Compose est également installé.
- `Git` : Pour gérer le versionnement de votre projet.

### Configuration de Git avec SSH sur le VPS

Pour utiliser Git avec SSH sur votre VPS, suivez les étapes suivantes :

#### Étape 1 : Installer Git
Si Git n'est pas déjà installé, installez-le sur votre VPS :
```bash
sudo apt update
sudo apt install git -y
```

#### Étape 2 : Configurer votre identité Git

Définissez votre nom d'utilisateur et votre email global pour Git :

```bash
git config --global user.name "VotreNom"
git config --global user.email "VotreEmail@example.com"
```

Vous pouvez vérifier la configuration avec :
```bash
git config --list
```
#### Étape 3 : Générer une clé SSH

Créez une nouvelle paire de clés SSH pour authentifier vos opérations Git avec GitHub :

```bash
ssh-keygen -t ed25519 -C "VotreEmail@example.com"
```
```bash
ssh-keygen -t ed25519 -C "votre_email@example.com" -N "" -f ~/.ssh/id_ed25519_deploie
```
- Lorsque demandé, appuyez sur Entrée pour utiliser l'emplacement par défaut (~/.ssh/id_ed25519).
- Optionnel : Ajoutez une passphrase pour plus de sécurité.

#### Étape 4 : Ajouter la clé SSH à l'agent

Activez l'agent SSH et ajoutez votre clé privée :

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

#### Étape 5 : Ajouter la clé publique à GitHub

1. Affichez le contenu de votre clé publique :
```bash
cat ~/.ssh/id_ed25519.pub
```
2. Copiez la clé affichée.
3. Connectez-vous à GitHub, puis allez dans Settings > SSH and GPG keys > New SSH Key.
4. Collez votre clé publique et donnez-lui un nom descriptif (par exemple, `VPS`).

#### Étape 6 : Tester la connexion SSH

Vérifiez que la connexion avec GitHub fonctionne correctement :
```bash
ssh -T git@github.com
```
Vous devriez voir un message confirmant que l'authentification est réussie.

### Gestion des utilisateurs sur le VPS

#### Modifier le mot de passe de l'utilisateur actuel
Si vous devez modifier le mot de passe de l'utilisateur actuel sur votre VPS, suivez les étapes ci-dessous :

#### Connectez-vous au VPS via SSH
Utilisez la commande suivante pour changer le mot de passe de l'utilisateur connecté :
```bash
whoami
```
puis 
```bash 
 sudo passwd <user_actuel>
```
Entrez le nouveau mot de passe lorsqu'il est demandé. Confirmez-le.
Cette commande met à jour le mot de passe de l'utilisateur actuel.

#### Créer un nouvel utilisateur avec un mot de passe

- Créez le nouvel utilisateur en remplaçant nouvel_utilisateur par le nom souhaité :

```bash
sudo adduser nouvel_utilisateur
```
Vous serez invité à définir un mot de passe et des informations supplémentaires (facultatives).

- (Optionnel) Donnez à cet utilisateur des privilèges administratifs (sudo) :

```bash
sudo usermod -aG sudo nouvel_utilisateur
```

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
