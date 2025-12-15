COMPOSE_FILE = srcs/docker-compose.yml
DATA_DIR = /home/nfararan/data
SECRETS_DIR = secrets
COMPOSE_CMD = docker compose
ENV_DIR = srcs

.DEFAULT_GOAL := help

help:
	@echo "Inception - Available commands:"
	@echo ""
	@echo "  make setup      - Configure the environment (secrets, dossiers)"
	@echo "  make up         - Start all services"
	@echo "  make down       - Stop all services"
	@echo "  make restart    - Restart all services"
	@echo "  make logs       - Show all services logs"
	@echo "  make ps         - Show all services state"
	@echo "  make build      - Build all Docker images"
	@echo "  make clean      - Stop and remove all containers"
	@echo ""

setup:
	@echo "Setting up environment..."
	@mkdir -p $(DATA_DIR)/db_data $(DATA_DIR)/wp_data
	@mkdir -p $(SECRETS_DIR)
	@test -f $(SECRETS_DIR)/db_pass.txt || echo "wordpress_password" > $(SECRETS_DIR)/db_pass.txt
	@test -f $(SECRETS_DIR)/db_root_pass.txt || echo "root_password" > $(SECRETS_DIR)/db_root_pass.txt
	@echo "✅ Secrets created !"
	@test -f $(ENV_DIR)/.env || echo "DB_USER=the_inception_user" > $(ENV_DIR)/.env
	@test -f $(ENV_DIR)/.env || echo "DB_NAME=the_inception_database" >> $(ENV_DIR)/.env
	@echo "✅ Environment variables created !"
	@echo "✅ Setup finished !"

build:
	@echo "Building Docker images..."
	@$(COMPOSE_CMD) -f $(COMPOSE_FILE) build
	@echo "✅ Build finished !"

up: setup
	@echo "Starting services..."
	@$(COMPOSE_CMD) -f $(COMPOSE_FILE) up -d
	@echo "✅ Services started ! Go to https://nfararan.42.fr"

down:
	@echo "Stopping services..."
	@$(COMPOSE_CMD) -f $(COMPOSE_FILE) down
	@echo "✅ Services stopped !"

restart:
	@echo "Restarting services..."
	@$(MAKE) down
	@$(MAKE) up
	@echo "✅ Services restarted !"

logs:
	@echo "Showing logs..."
	@$(COMPOSE_CMD) -f $(COMPOSE_FILE) logs -f

ps:
	@echo "Services state: "
	@$(COMPOSE_CMD) -f $(COMPOSE_FILE) ps

clean:
	@echo "Cleaning environment..."
	@$(COMPOSE_CMD) -f $(COMPOSE_FILE) down -v
	@echo "✅ Environment cleaned !"

.PHONY: help setup build up down restart logs ps clean
