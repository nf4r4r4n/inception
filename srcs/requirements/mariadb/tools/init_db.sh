#!/bin/bash

set -e

add_sql() {
    echo "$1" >> $INIT_FILE
}

log() {
    echo -e "\e[34m[MARIADB_INCEPTION]\e[0m $1"
}

if [ ! -f "/run/secrets/db_pass" ] || [ ! -f "/run/secrets/db_root_pass" ]; then
    log "Database passwords are not set."
    exit 1
fi

INIT_FILE="/tmp/init.sql"
DB_PASS=$(cat /run/secrets/db_pass)
DB_ROOT_PASS=$(cat /run/secrets/db_root_pass)
DB_USER=${DB_USER}
DB_NAME=${DB_NAME}
DB_USER_MANAGER=${DB_USER_MANAGER}

mkdir -p /var/run/mysqld /var/log/mysql
chown mysql:mysql /var/run/mysqld /var/log/mysql
chown -R mysql:mysql /var/lib/mysql

log "Starting temporary MariaDB..."

mysqld --user=mysql --datadir=/var/lib/mysql --socket=/var/run/mysqld/mysqld.sock \
       --pid-file=/var/run/mysqld/mysqld.pid --skip-networking --skip-grant-tables \
       --skip-name-resolve --bind-address=127.0.0.1 &

MYSQLD_PID=$!
sleep 10

if ! kill -0 $MYSQLD_PID 2>/dev/null; then
    log "MariaDB failed to start."
    if [ -f /var/log/mysql/error.log ]; then
        log "Error log content:"
        cat /var/log/mysql/error.log
    fi
    exit 1
fi

log "MariaDB started with PID $MYSQLD_PID"

touch $INIT_FILE

log "Creating Users & Database..."
add_sql "FLUSH PRIVILEGES;"
add_sql "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';"
add_sql "CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
add_sql "CREATE USER IF NOT EXISTS '$DB_USER_MANAGER'@'%' IDENTIFIED BY '$DB_ROOT_PASS';"
add_sql "CREATE USER IF NOT EXISTS '$DB_USER_MANAGER'@'localhost' IDENTIFIED BY '$DB_ROOT_PASS';"
add_sql "GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'%' WITH GRANT OPTION;"
add_sql "GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'localhost' WITH GRANT OPTION;"
add_sql "GRANT ALL PRIVILEGES ON *.* TO '$DB_USER_MANAGER'@'%' WITH GRANT OPTION;"
add_sql "GRANT ALL PRIVILEGES ON *.* TO '$DB_USER_MANAGER'@'localhost' WITH GRANT OPTION;"

add_sql "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8 COLLATE utf8_general_ci;"
add_sql "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"
add_sql "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
add_sql "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER_MANAGER'@'%';"
add_sql "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER_MANAGER'@'localhost';"
add_sql "FLUSH PRIVILEGES;"

mysql --socket=/var/run/mysqld/mysqld.sock -u root --password="" < $INIT_FILE
log "Users & Database created."

log "Stopping temporary MariaDB..."
mysqladmin --socket=/var/run/mysqld/mysqld.sock -u root --password="" shutdown
log "MariaDB stopped."

rm -f $INIT_FILE

exec /usr/sbin/mysqld --user=mysql --datadir=/var/lib/mysql