FROM debian:bookworm-slim

# Mettre à jour les paquets et installer nginx et openssl
RUN apt update -y && \
	apt install -y --no-install-recommends nginx openssl && \
	apt clean && \
	rm -rf /var/lib/apt/lists/*

# Supprimer la configuration par défaut de nginx
RUN rm -rf /etc/nginx/sites-enabled/default

# Créer les répertoires pour les certificats SSL
RUN mkdir -p /etc/ssl/certs /etc/ssl/private

# Générer un certificat SSL auto-signé
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt \
	-subj "/C=FR/ST=France/L=Paris/O=42/OU=Inception/CN=localhost"

# Copier la configuration nginx
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# Exposer les ports
EXPOSE 443

# Démarrer nginx
CMD ["nginx", "-g", "daemon off;"]
