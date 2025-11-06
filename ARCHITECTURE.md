# Architecture du Projet Inception 42

## Vue d'ensemble

Le projet Inception 42 déploie une infrastructure complète pour héberger un site WordPress avec une sécurité et une performance optimales. L'architecture repose sur 3 services principaux conteneurisés avec Docker.

## Services

### 1. Nginx
- **Rôle** : Serveur web et reverse proxy
- **Fonction** : Gestion des requêtes HTTP/HTTPS, proxy vers PHP-FPM
- **Ports exposés** : 80 (redirection vers 443), 443
- **Configuration** : SSL/TLS avec certificat auto-signé
- **Sécurité** : Headers de sécurité, protection contre les attaques courantes

### 2. MariaDB
- **Rôle** : Serveur de base de données
- **Fonction** : Stockage des données WordPress
- **Ports exposés** : 3306 (interne uniquement)
- **Sécurité** : Utilisation de secrets pour les mots de passe, accès restreint
- **Persistance** : Volume Docker pour conserver les données

### 3. WordPress
- **Rôle** : Système de gestion de contenu
- **Fonction** : Exécution de PHP-FPM pour traiter les requêtes WordPress
- **Communication** : Connexion à MariaDB via réseau Docker interne
- **Persistance** : Volume pour les fichiers uploadés et configurations

## Réseaux

Deux réseaux Docker sont utilisés :
- **frontend** : Pour la communication entre Nginx et l'extérieur
- **backend** : Pour la communication sécurisée entre services internes (WordPress et MariaDB)

## Volumes

Deux volumes persistants assurent la conservation des données :
- **db_data** : Stockage des données MariaDB
- **wp_data** : Stockage des fichiers WordPress (thèses, plugins, médias)

## Sécurité

- Les mots de passe sont gérés via des secrets Docker
- Isolation réseau entre les services
- SSL/TLS pour la communication web
- Limitation des ports exposés à l'extérieur

## Orchestration

L'ensemble est orchestré via Docker Compose qui gère :
- Démarrage séquentiel des services (MariaDB → WordPress → Nginx)
- Configuration des réseaux
- Configuration des volumes
- Gestion des dépendances entre services