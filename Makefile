# Variables
COMPOSE_FILE = srcs/docker-compose.yml
DATA_DIR = /home/nfararan/data
SECRETS_DIR = secrets

# Cible par défaut
.DEFAULT_GOAL := help

# Afficher l'aide
help: ## Afficher ce message d'aide
	@echo "Inception - Commandes disponibles :"
	@echo ""
	@echo "  make setup      - Configurer l'environnement (secrets, dossiers)"
	@echo "  make up         - Démarrer tous les services"
	@echo "  make down       - Arrêter tous les services"
	@echo "  make restart    - Redémarrer tous les services"
	@echo "  make logs       - Afficher les logs de tous les services"
	@echo "  make ps         - Afficher l'état des services"
	@echo "  make build      - Construire les images Docker"
	@echo "  make clean      - Arrêter et supprimer tous les conteneurs"
	@echo ""

# Configurer l'environnement
setup: ## Configurer l'environnement (secrets, dossiers)
	@echo "Configuration de l'environnement..."
	@mkdir -p $(DATA_DIR)/db_data $(DATA_DIR)/wp_data
	@mkdir -p $(SECRETS_DIR)
	@test -f $(SECRETS_DIR)/db_pass.txt || echo "wordpress_password" > $(SECRETS_DIR)/db_pass.txt
	@test -f $(SECRETS_DIR)/db_root_pass.txt || echo "root_password" > $(SECRETS_DIR)/db_root_pass.txt
	@echo "Environnement configuré !"

# Construire les images
build: ## Construire les images Docker
	@echo "Construction des images Docker..."
	@docker-compose -f $(COMPOSE_FILE) build
	@echo "Construction terminée !"

# Démarrer les services
up: setup ## Démarrer tous les services
	@echo "Démarrage des services..."
	@docker-compose -f $(COMPOSE_FILE) up -d
	@echo "Services démarrés ! Accédez à https://localhost"

# Arrêter les services
down: ## Arrêter tous les services
	@echo "Arrêt des services..."
	@docker-compose -f $(COMPOSE_FILE) down
	@echo "Services arrêtés !"

# Redémarrer les services
restart: ## Redémarrer tous les services
	@echo "Redémarrage des services..."
	@$(MAKE) down
	@$(MAKE) up
	@echo "Services redémarrés !"

# Afficher les logs
logs: ## Afficher les logs de tous les services
	@echo "Affichage des logs..."
	@docker-compose -f $(COMPOSE_FILE) logs -f

# Afficher l'état des services
ps: ## Afficher l'état des services
	@echo "État des services :"
	@docker-compose -f $(COMPOSE_FILE) ps

# Nettoyer l'environnement
clean: ## Arrêter et supprimer tous les conteneurs
	@echo "Nettoyage de l'environnement..."
	@docker-compose -f $(COMPOSE_FILE) down -v
	@echo "Environnement nettoyé !"

# Liste des commandes avec descriptions
.PHONY: help setup build up down restart logs ps clean
