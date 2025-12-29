FROM debian:bookworm-slim

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

RUN mkdir -p /run/php /var/www/html

COPY ./tools/entrypoint.sh /entrypoint.sh
COPY ./tools/www.conf /etc/php/8.2/fpm/pool.d/www.conf

RUN chmod +x /entrypoint.sh

WORKDIR /var/www/html

VOLUME /var/www/html

EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/sbin/php-fpm8.2", "--nodaemonize"]
