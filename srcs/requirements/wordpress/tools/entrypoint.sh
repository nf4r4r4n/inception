#!/bin/bash

set -e

# Install Wordpress CLI
if command -v wp &> /dev/null; then
    echo "WP cli already exists"
else
    wget --no-check-certificate https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar &> /dev/null
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Wait for the MariaDB
echo "Waiting for MariaDB to be ready..."
until mysql -h mariadb -u $WORDPRESS_DB_USER -p$(cat $WORDPRESS_DB_PASSWORD_FILE) -e "SHOW DATABASES;"; do
  sleep 3
  echo "Retrying database connection..."
done

# Wordpress installation
if [ ! -f wp-config.php ]; then
    echo "Creating wp-config.php file..."

    wp core download --insecure --allow-root

    # Database and configuration
    wp config create --allow-root \
        --dbname=$WORDPRESS_DB_NAME \
        --dbuser=$WORDPRESS_DB_USER_MANAGER \
        --dbpass=$(cat $WORDPRESS_DB_MANAGER_PASSWORD_FILE) \
        --dbhost=$WORDPRESS_DB_HOST

    # Website creation
    wp core install --allow-root \
        --url=https://nfararan.42.fr \
        --title="Nfararan Inception" \
        --admin_user=$WORDPRESS_DB_USER_MANAGER \
        --admin_password=$(cat $WORDPRESS_DB_MANAGER_PASSWORD_FILE) \
        --admin_email="test@example.com"

    # Simple user creation
    wp user create --allow-root \
        $WORDPRESS_DB_USER \
        simple@example.com \
        --role=author \
        --user_pass=$(cat $WORDPRESS_DB_PASSWORD_FILE)

    chown www-data:www-data wp-config.php
    chmod 644 wp-config.php
else
    echo "Wordpress already configured"
fi

exec "$@"