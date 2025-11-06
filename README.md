# Projet Inception 42

Ce projet déploie une infrastructure complète avec Nginx, MariaDB et WordPress à l'aide de Docker et Docker Compose.

## Architecture

Le projet comprend 3 services :
- **Nginx** : Serveur web avec SSL
- **MariaDB** : Base de données
- **WordPress** : Système de gestion de contenu

## Prérequis

- Docker
- Docker Compose
- Make (optionnel)

## Installation

1. Clonez ce dépôt
2. Assurez-vous d'avoir créé les dossiers de données persistantes
3. Lancez les services avec Docker Compose

## Démarrage

Pour lancer le projet :

```bash
cd srcs
docker-compose up -d
```

Les services seront accessibles à :
- WordPress : https://localhost (redirige depuis HTTP)
- phpMyAdmin (optionnel) : à ajouter si nécessaire

## Structure du projet

```
inception/
├── srcs/
│   ├── docker-compose.yml
│   ├── .env
│   └── requirements/
│       ├── nginx/
│       │   ├── Dockerfile
│       │   └── conf/
│       ├── mariadb/
│       │   ├── Dockerfile
│       │   ├── conf/
│       │   └── tools/
│       └── wordpress/
│           ├── Dockerfile
│           ├── conf/
│           └── tools/
├── secrets/
│   ├── db_pass.txt
│   └── db_root_pass.txt
└── data/
    ├── db_data/
    └── wp_data/
```

## Sécurité

- Les mots de passe sont gérés via des secrets Docker
- SSL activé pour la communication web
- Isolation réseau entre les services