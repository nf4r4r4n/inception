FROM debian:bookworm-slim

RUN apt update && \
	apt install -y --no-install-recommends mariadb-server && \
	apt clean && \
	rm -rf /var/lib/apt/lists/*

RUN rm -f /etc/systemd/system/mysqld.service /etc/init.d/mysql

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

COPY ./tools/init_db.sh /init_db.sh

RUN chmod +x /init_db.sh

EXPOSE 3306

ENTRYPOINT ["/init_db.sh"]
