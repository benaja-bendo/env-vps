# Création des base de donnée

1. Trouver le nom de ton conteneur PostgreSQL  

    ```bash
    docker ps
    ````

2. Exécuter une commande psql

    ```bash
    docker exec -it <nom_du_conteneur> psql -U <nom_utilisateur> -c "CREATE DATABASE node-api;"
    ```
