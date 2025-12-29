FROM debian:bookworm-slim

# Install nginx and openssl
RUN apt update -y && \
	apt install -y --no-install-recommends nginx openssl && \
	apt clean && \
	rm -rf /var/lib/apt/lists/*

# Delete nginx configuration by default
RUN rm -rf /etc/nginx/sites-enabled/default

# Create folders for SSL certificates
RUN mkdir -p /etc/ssl/certs /etc/ssl/private

# Generate auto signed certificate for SSL
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt \
	-subj "/C=FR/ST=France/L=Paris/O=42/OU=Inception/CN=localhost"

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
