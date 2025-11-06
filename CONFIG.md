# Configuration du projet Inception 42

## Variables d'environnement

Le projet utilise un fichier `.env` pour stocker les variables sensibles :
- DB_USER : Nom d'utilisateur pour la base de données WordPress
- DB_NAME : Nom de la base de données WordPress

## Ports

- Port 80 : Redirigé vers le port 443 (HTTP vers HTTPS)
- Port 443 : Accès HTTPS à WordPress via Nginx
- Port 3306 : Accès à MariaDB (restreint au réseau interne)

## Certificats SSL

Le projet utilise un certificat SSL auto-signé. Pour un déploiement en production, remplacez le certificat par un certificat valide.

## Configuration PHP

Le service WordPress est configuré avec PHP-FPM pour une meilleure performance et sécurité :
- Extensions PHP nécessaires pour WordPress préinstallées
- Paramètres de sécurité appropriés
- Gestion des erreurs configurée

## Configuration MariaDB

- Base de données optimisée pour WordPress
- Utilisateurs et permissions configurés
- Paramètres de performance ajustés
- Journalisation configurée

## Volumes persistants

Le projet utilise des volumes pour conserver les données critiques :
- Volume `db_data` pour les données de la base MariaDB
- Volume `wp_data` pour les fichiers WordPress

## Sécurité

- Les mots de passe sont gérés via des secrets Docker
- Accès réseau limité via les réseaux Docker
- Headers de sécurité configurés dans Nginx
- Protection contre les attaques communes