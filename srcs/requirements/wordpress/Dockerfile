FROM debian:bullseye-slim

# Installer PHP et les extensions nécessaires
RUN apt update && \
    apt install -y --no-install-recommends \
        php-fpm \
        php-mysql \
        php-curl \
        php-gd \
        php-mbstring \
        php-xml \
        php-xmlrpc \
        php-soap \
        php-intl \
        php-zip \
        php-opcache \
        wget \
        mariadb-client && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Créer les répertoires nécessaires
RUN mkdir -p /run/php /var/www/html

# Définir le répertoire de travail
WORKDIR /tmp

# Télécharger et extraire WordPress
RUN wget --no-check-certificate https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    rm -rf latest.tar.gz

# Copier les fichiers WordPress vers le répertoire de destination
RUN cp -r wordpress/* /var/www/html/ && \
    rm -rf wordpress

# Copier les scripts et configurations
COPY ./tools/entrypoint.sh /entrypoint.sh
COPY ./tools/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Rendre les scripts exécutables
RUN chmod +x /entrypoint.sh

# Définir les permissions appropriées
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Définir le répertoire de travail WordPress
WORKDIR /var/www/html

# Volume pour les données persistantes
VOLUME /var/www/html

# Exposer le port
EXPOSE 9000

# Point d'entrée
ENTRYPOINT ["/entrypoint.sh"]

# Démarrer PHP-FPM en mode premier plan
CMD ["/usr/sbin/php-fpm7.4", "--nodaemonize"]
