FROM debian:bullseye-slim

# Installer MariaDB
RUN apt update && \
    apt install -y --no-install-recommends mariadb-server && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Désactiver le service MariaDB pour empêcher le démarrage automatique
RUN rm -f /etc/systemd/system/mysqld.service /etc/init.d/mysql

# Copier la configuration
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

# Copier les scripts
COPY ./tools/init_db.sh /init_db.sh

# Rendre les scripts exécutables
RUN chmod +x /init_db.sh

# Exposer le port
EXPOSE 3306

# Point d'entrée
ENTRYPOINT ["/init_db.sh"]