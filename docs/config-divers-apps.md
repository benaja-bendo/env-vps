avec la configration de traefik que ce projet propose, ce fichier a pour but de vos aide à facilement mettre en place la dockerisation de differents types d'applications que adpaterez avec vos besions:

Note:
- PathPrefix: c'est le chemin qui sera utilisé pour accéder à l'application
- Loadbalancer: c'est le nom du service qui sera utilisé pour accéder à l'application
- Port: c'est le port qui sera utilisé pour accéder à l'application
- Protocol: c'est le protocol qui sera utilisé pour accéder à l'application
- 

- pour une simple application qui veux utilise appache, php, mysql, phpmyadmin, etc...
 voici la configuration du docker-compose.yml:

```yaml
services:
  apache:
    image: httpd:latest
    container_name: apache-service
    networks:
      - traefik_network
    labels:
      - traefik.enable=true
      - traefik.http.routers.apache.rule=PathPrefix(`/apache`)
      - traefik.http.routers.apache.entrypoints=web
      - traefik.http.middlewares.apache-stripprefix.stripprefix.prefixes=/apache
      - traefik.http.routers.apache.middlewares=apache-stripprefix
      #- traefik.http.routers.apache-secure.rule=PathPrefix(`/apache`)
      #- traefik.http.routers.apache-secure.entrypoints=websecure
      #- traefik.http.routers.apache-secure.tls=true
      #- traefik.http.routers.apache-secure.tls.certresolver=cloudflare
networks:
  traefik_network:
    external: true
```

- une application qui veux utilisé caddy serveur 

```yml
services:
  caddy:
      image: caddy:latest
      container_name: caddy-service
      networks:
        - traefik_network
      labels:
        - traefik.enable=true
        - traefik.http.routers.caddy.rule=PathPrefix(`/caddy`)
        - traefik.http.routers.caddy.entrypoints=web
        - traefik.http.middlewares.caddy-stripprefix.stripprefix.prefixes=/caddy
        - traefik.http.routers.caddy.middlewares=caddy-stripprefix
        #- traefik.http.routers.caddy-secure.rule=PathPrefix(`/caddy`)
        #- traefik.http.routers.caddy-secure.entrypoints=websecure
        #- traefik.http.routers.caddy-secure.tls=true
        #- traefik.http.routers.caddy-secure.tls.certresolver=cloudflare
networks:
  traefik_network:
    external: true
```

- pour une application laravel dans sa version 11:
  - Dockerfile:
```yml
# Utiliser l'image de base alpine pour PHP 8.3
FROM php:8.3-fpm-alpine

# Installer les dépendances nécessaires
RUN apk update && apk add --no-cache \
    bash \
    git \
    curl \
    zip \
    unzip \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    postgresql-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql pdo_pgsql

# Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Définir le répertoire de travail
WORKDIR /var/www

# Copier les fichiers de l'application
COPY . /var/www

# Installer les dépendances Laravel
# RUN composer install --optimize-autoloader --no-dev
RUN composer install --optimize-autoloader

# Définir les permissions
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www/storage /var/www/bootstrap/cache

# Exposer le port pour PHP-FPM
EXPOSE 9000

# Lancer PHP-FPM
CMD ["php-fpm"]
```
- docker-compose.yml:
```yml
services:
  laravel-app:
    build:
      context: .
      dockerfile: Dockerfile
    image: laravel-app
    container_name: laravel-app
    environment:
      - APP_ENV=local
      - APP_DEBUG=true
      - APP_URL=${APP_URL}
      - APP_HOST=${APP_HOST}
      - APP_KEY=${APP_KEY}
      - DB_CONNECTION=pgsql
      - DB_HOST=${DB_HOST}
      - DB_DATABASE=${DB_DATABASE}
      - DB_USERNAME=${DB_USERNAME}
      - DB_PASSWORD=${DB_PASSWORD}
    volumes:
      - .:/var/www/html
    networks:
      - traefik_network

  laravel-nginx:
    image: nginx:latest
    container_name: laravel-nginx
    depends_on:
      - laravel-app
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
      - .:/var/www/html
    networks:
      - traefik_network
    labels:
      - traefik.enable=true
      - traefik.http.routers.laravel-app.rule=PathPrefix(`/laravel-app`)
      - traefik.http.middlewares.laravel-app-stripprefix.stripprefix.prefixes=/laravel-app
      - traefik.http.routers.laravel-app.middlewares=laravel-app-stripprefix
      - traefik.http.routers.laravel-app.entrypoints=web
      - traefik.http.services.laravel-app.loadbalancer.server.port=80

networks:
  traefik_network:
    external: true

```

- nginx.conf:
```yml
server {
    listen 80;
    server_name laravel.local;

    root /var/www/public;
    index index.php index.html;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass laravel-app:9000; # Correspond au conteneur PHP
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }

    location ~ /\.ht {
        deny all;
    }
}
```

- une application qui veux utilisé nodejs:
  - Dockerfile:
```yml
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
````

- docker-compose.yml:
```yml
services:
  node-api:
    container_name: node-api-service
    build: .
    restart: always
    environment:
      - PORT=3000
    networks:
      - traefik_network
    labels:
      - traefik.enable=true
      - traefik.http.routers.node-api.rule=Host(`${SERVER_IP}`)
      # - traefik.http.routers.node-api.rule=PathPrefix(`/node-api`)
      # - traefik.http.middlewares.node-api-stripprefix.stripprefix.prefixes=/node-api
      # - traefik.http.routers.node-api.middlewares=node-api-stripprefix
      # - traefik.http.routers.node-api.entrypoints=web
      - traefik.http.routers.node-api.entrypoints=websecure
      - traefik.http.routers.node-api.tls.certresolver=letsencrypt
      - traefik.http.services.node-api.loadbalancer.server.port=3000

    expose:
      - 3000
networks:
  traefik_network:
    external: true
```

