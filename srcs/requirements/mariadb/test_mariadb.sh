#!/bin/bash

# Script de test pour déboguer le démarrage de MariaDB

echo "Vérification de l'utilisateur mysql..."
id mysql

echo "Vérification des permissions du répertoire /var/lib/mysql..."
ls -la /var/lib/mysql

echo "Test de démarrage de MariaDB..."
# Essayons de démarrer MariaDB avec un utilisateur root (temporairement pour test)
mysqld --user=root --datadir=/var/lib/mysql --socket=/tmp/test.sock --port=3308 --skip-networking=0 --console &
MYSQLD_PID=$!

sleep 5

echo "PID du processus mysqld: $MYSQLD_PID"

if kill -0 $MYSQLD_PID 2>/dev/null; then
  echo "MariaDB est en cours d'exécution"
  # Essayons de se connecter
  mysqladmin --socket=/tmp/test.sock -u root --password="" ping
  if [ $? -eq 0 ]; then
    echo "Connexion à MariaDB réussie"
  else
    echo "Échec de la connexion à MariaDB"
  fi
  # Arrêter le serveur
  mysqladmin --socket=/tmp/test.sock -u root --password="" shutdown
else
  echo "MariaDB n'a pas démarré correctement"
fi

wait $MYSQLD_PID 2>/dev/null || true