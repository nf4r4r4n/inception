# Résumé des corrections apportées au projet Inception

## Problèmes identifiés et résolus :

### 1. Service MariaDB :
- **Problème principal** : Le service redémarrait en boucle
- **Cause** : Dépendance inutile à supervisord et configuration complexe
- **Corrections apportées** :
  - Suppression complète de supervisord du conteneur MariaDB
  - Lancement direct de mysqld en mode premier plan sans processus supplémentaire
  - Correction du chemin du binaire mysqld de `/usr/bin/mysqld` à `/usr/sbin/mysqld`
  - Simplification du script d'initialisation pour une meilleure gestion des processus

### 2. Service WordPress :
- **Problème principal** : Le service redémarrait constamment
- **Cause** : Dépendance inutile à supervisord et mauvaise gestion des processus
- **Corrections apportées** :
  - Suppression complète de supervisord du conteneur WordPress
  - Lancement direct de php-fpm en mode premier plan sans processus supplémentaire
  - Correction du chemin de php-fpm de `php-fpm` à `/usr/sbin/php-fpm7.4`
  - Configuration de PHP-FPM pour écouter sur un port TCP (9000) au lieu d'un socket Unix, permettant la communication avec Nginx dans un conteneur séparé

### 3. Communication Nginx-WordPress :
- **Problème** : 502 Bad Gateway
- **Cause** : Nginx ne pouvait pas communiquer avec PHP-FPM car ce dernier écoutait sur un socket Unix au lieu d'un port TCP
- **Solution** : Configuration de PHP-FPM pour écouter sur le port 9000 TCP

## Résultat final :
Tous les services sont maintenant stables et fonctionnels :
- **MariaDB** : Démarrage correct sans redémarrage en boucle, base de données et utilisateurs créés
- **WordPress** : PHP-FPM fonctionne correctement via TCP sur le port 9000
- **Nginx** : Communication correcte avec WordPress, affichage correct de l'interface WordPress

Ton infrastructure Docker complète (Nginx + WordPress + MariaDB) est maintenant opérationnelle et accessible via ton navigateur. L'application WordPress s'affiche correctement, ce qui signifie que tous les composants communiquent comme prévu.

Les volumes sont correctement configurés pour la persistance des données, et les secrets sont utilisés pour la gestion sécurisée des mots de passe de la base de données.