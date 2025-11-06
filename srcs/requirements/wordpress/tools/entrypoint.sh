#!/bin/bash

set -e

# Attendre que MariaDB soit prêt
echo "Waiting for MariaDB to be ready..."
until mysql -h mariadb -u $WORDPRESS_DB_USER -p$(cat $WORDPRESS_DB_PASSWORD_FILE) -e "SHOW DATABASES;"; do
  sleep 3
  echo "Retrying database connection..."
done

# Vérifier si WordPress est déjà installé
if [ ! -f wp-config.php ]; then
    echo "Creating wp-config.php file..."

    # Générer des clés de sécurité
    AUTH_KEY=$(openssl rand -base64 65 | tr -d '\n')
    SECURE_AUTH_KEY=$(openssl rand -base64 65 | tr -d '\n')
    LOGGED_IN_KEY=$(openssl rand -base64 65 | tr -d '\n')
    NONCE_KEY=$(openssl rand -base64 65 | tr -d '\n')
    AUTH_SALT=$(openssl rand -base64 65 | tr -d '\n')
    SECURE_AUTH_SALT=$(openssl rand -base64 65 | tr -d '\n')
    LOGGED_IN_SALT=$(openssl rand -base64 65 | tr -d '\n')
    NONCE_SALT=$(openssl rand -base64 65 | tr -d '\n')

    # Créer le fichier wp-config.php
    cat > wp-config.php << EOF
<?php
define('DB_NAME', '${WORDPRESS_DB_NAME}');
define('DB_USER', '${WORDPRESS_DB_USER}');
define('DB_PASSWORD', '$(cat $WORDPRESS_DB_PASSWORD_FILE)');
define('DB_HOST', '${WORDPRESS_DB_HOST}');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

define('AUTH_KEY',         '${AUTH_KEY}');
define('SECURE_AUTH_KEY',  '${SECURE_AUTH_KEY}');
define('LOGGED_IN_KEY',    '${LOGGED_IN_KEY}');
define('NONCE_KEY',        '${NONCE_KEY}');
define('AUTH_SALT',        '${AUTH_SALT}');
define('SECURE_AUTH_SALT', '${SECURE_AUTH_SALT}');
define('LOGGED_IN_SALT',   '${LOGGED_IN_SALT}');
define('NONCE_SALT',       '${NONCE_SALT}');

\$table_prefix = 'wp_';

define('WP_DEBUG', false);

if ( !defined('ABSPATH') )
    define('ABSPATH', dirname(__FILE__) . '/');

require_once(ABSPATH . 'wp-settings.php');
EOF

    # Changer les permissions du fichier de configuration
    chown www-data:www-data wp-config.php
    chmod 644 wp-config.php
fi

# Démarrer le service
exec "$@"