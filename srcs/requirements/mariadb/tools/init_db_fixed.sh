#!/bin/bash

set -e

# Fonction pour ajouter des commandes SQL
add_sql() {
    echo "$1" >> $INIT_FILE
}

# Fonction de journalisation
log() {
    echo -e "\e[34m[MARIADB_INCEPTION]\e[0m $1"
}

# Vérifier si les mots de passe sont définis
if [ ! -f "/run/secrets/db_pass" ] || [ ! -f "/run/secrets/db_root_pass" ]; then
    log "Database passwords are not set."
    exit 1
fi

INIT_FILE="/tmp/init.sql"
DB_PASS=$(cat /run/secrets/db_pass)
DB_ROOT_PASS=$(cat /run/secrets/db_root_pass)
DB_USER=${DB_USER:-wordpress_user}
DB_NAME=${DB_NAME:-wordpress_db}

# Initialiser le répertoire de données si nécessaire
if [ ! -d "/var/lib/mysql" ] || [ -z "$(ls -A /var/lib/mysql)" ]; then
    log "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null 2>&1
fi

# Démarrer MariaDB en tâche de fond avec un socket temporaire
log "Starting temporary MariaDB..."
mysqld --user=mysql --datadir=/var/lib/mysql --socket=/tmp/mysql.sock --port=3307 --skip-networking=0 --skip-name-resolve &
MYSQLD_PID=$!
sleep 10

# Vérifier que le processus est actif
if ! kill -0 $MYSQLD_PID 2>/dev/null; then
    log "MariaDB failed to start."
    exit 1
fi

log "MariaDB started with PID $MYSQLD_PID"

# Créer le fichier SQL d'initialisation
touch $INIT_FILE

log "Creating Users & Database..."
# Création des utilisateurs
add_sql "CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
add_sql "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';"
add_sql "GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'localhost' WITH GRANT OPTION;"
add_sql "GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'%' WITH GRANT OPTION;"
add_sql "CREATE USER IF NOT EXISTS 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASS';"
add_sql "CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '$DB_ROOT_PASS';"
add_sql "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;"
add_sql "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"
add_sql "FLUSH PRIVILEGES;"
# Création de la base de données
add_sql "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
add_sql "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
add_sql "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"
add_sql "GRANT ALL PRIVILEGES ON $DB_NAME.* TO 'root'@'localhost';"
add_sql "GRANT ALL PRIVILEGES ON $DB_NAME.* TO 'root'@'%';"
add_sql "FLUSH PRIVILEGES;"

# Exécuter les commandes SQL
mysql --socket=/tmp/mysql.sock -u root --password="" < $INIT_FILE
log "Users & Database created."

log "Stopping temporary MariaDB..."
mysqladmin --socket=/tmp/mysql.sock -u root --password="" shutdown
log "MariaDB stopped."

# Supprimer le fichier d'initialisation
rm -f $INIT_FILE

# Lancer MariaDB directement
exec /usr/sbin/mysqld --user=mysql --datadir=/var/lib/mysql