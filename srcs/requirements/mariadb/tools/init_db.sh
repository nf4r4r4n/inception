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

touch $INIT_FILE

log "Starting temporary MariaDB..."
# Démarrer MariaDB manuellement
mysqld --user=mysql --console --skip-name-resolve --skip-networking=0 &
# Attendre que le serveur soit prêt
sleep 5

# Vérifier que MariaDB est démarré
for i in {30..0}; do
    if mysqladmin -u root ping &> /dev/null; then
        break
    fi
    log "Waiting for MariaDB to start..."
    sleep 1
done

if [ "$i" = 0 ]; then
    log "MariaDB did not start in time."
    exit 1
fi

log "MariaDB started"

log "Creating Users & Database..."
# Création des utilisateurs
add_sql "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';"
add_sql "GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'%' WITH GRANT OPTION;"
add_sql "CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '$DB_ROOT_PASS';"
add_sql "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"
add_sql "FLUSH PRIVILEGES;"
# Création de la base de données
add_sql "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
add_sql "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"
add_sql "GRANT ALL PRIVILEGES ON $DB_NAME.* TO 'root'@'%';"
add_sql "FLUSH PRIVILEGES;"

mysql -u root < $INIT_FILE
log "Users & Database created."

log "Stopping temporary MariaDB..."
mysqladmin -u root shutdown
log "MariaDB stopped."

# Supprimer le fichier d'initialisation
rm -f $INIT_FILE

# Démarrer MariaDB normalement via supervisord
exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf