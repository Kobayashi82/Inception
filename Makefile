
#	╔═══════════════════════════════════╗
#	║              GENERAL              ║
#	╚═══════════════════════════════════╝


# Project name
NAME	= inception

# Colors
GREEN	= \033[0;32m
NC		= \033[0m

# Path to docker-compose.yml file
COMPOSE_FILE = srcs/docker-compose.yml


#	╔═══════════════════════════════════╗
#	║          CONTAINER RULES          ║
#	╚═══════════════════════════════════╝


all: up

# Starts containers in detached mode
up:
	@mkdir -p ~/data/mariadb ~/data/wordpress
	@docker compose -f $(COMPOSE_FILE) up -d || exit 1
	@printf "\n"

# Stops and removes containers
down:
	@docker compose -f $(COMPOSE_FILE) down || exit 1
	@printf "\n"

# Restarts containers
restart:
	@mkdir -p ~/data/mariadb ~/data/wordpress
	@docker compose -f $(COMPOSE_FILE) down || exit 1
	@docker compose -f $(COMPOSE_FILE) up -d || exit 1
	@printf "\n"


#	╔═══════════════════════════════════╗
#	║            BUILD RULES            ║
#	╚═══════════════════════════════════╝


# Builds containers
build:
	@mkdir -p ~/data/mariadb ~/data/wordpress
	@docker compose -f $(COMPOSE_FILE) down || exit 1
	@docker compose -f $(COMPOSE_FILE) build || exit 1
	@printf "\n ✔ Containers\t\t$(GREEN)Built$(NC)\n\n"

# Rebuilds containers
rebuild:
	@mkdir -p ~/data/mariadb ~/data/wordpress
	@docker compose -f $(COMPOSE_FILE) down || exit 1
	@docker compose -f $(COMPOSE_FILE) build --no-cache || exit 1
	@printf "\n ✔ Containers\t\t$(GREEN)Rebuilt$(NC)\n\n"


#	╔═══════════════════════════════════╗
#	║            CLEAN RULES            ║
#	╚═══════════════════════════════════╝


# Removes images
clean: iclean
iclean:
	@docker compose -f $(COMPOSE_FILE) down || exit 1
	@printf "\nplease wait...\n"
	@$(MAKE) -s _remove_images
	@printf "\033[1A\r%50s\r ✔ Images\t\t$(GREEN)Removed$(NC)\n\n"

# Removes volumes
vclean:
	@docker compose -f $(COMPOSE_FILE) down || exit 1
	@printf "\nplease wait...\n"
	@$(MAKE) -s _remove_volumes
	@printf "\033[1A\r%50s\r ✔ Volumes\t\t$(GREEN)Removed$(NC)\n\n"

# Removes network
nclean:
	@docker compose -f $(COMPOSE_FILE) down || exit 1
	@printf "\nplease wait...\n"
	@$(MAKE) -s _remove_network
	@printf "\033[1A\r%50s\r ✔ Network\t\t$(GREEN)Removed$(NC)\n\n"

# Removes images, volumes and network
fclean:
	@docker compose -f $(COMPOSE_FILE) down || exit 1
	@printf "\nplease wait...\n"
	@$(MAKE) -s _remove_images
	@$(MAKE) -s _remove_volumes
	@$(MAKE) -s _remove_network
	@printf "\033[1A\r%50s\r ✔ Images\t\t$(GREEN)Removed$(NC)\n"
	@printf " ✔ Volumes\t\t$(GREEN)Removed$(NC)\n"
	@printf " ✔ Network\t\t$(GREEN)Removed$(NC)\n\n"

# Removes images, volumes, network and cache
fcclean:
	@docker compose -f $(COMPOSE_FILE) down || exit 1
	@printf "\nplease wait...\n"
	@$(MAKE) -s _remove_images
	@$(MAKE) -s _remove_volumes
	@$(MAKE) -s _remove_network
	@docker builder prune -f > /dev/null 2>&1 || true
	@printf "\033[1A\r%50s\r ✔ Images\t\t$(GREEN)Removed$(NC)\n"
	@printf " ✔ Volumes\t\t$(GREEN)Removed$(NC)\n"
	@printf " ✔ Network\t\t$(GREEN)Removed$(NC)\n"
	@printf " ✔ Cache\t\t$(GREEN)Removed$(NC)\n\n"


#	╔═══════════════════════════════════╗
#	║           PRIVATE RULES           ║
#	╚═══════════════════════════════════╝


# Remove images
_remove_images:
	@docker rmi srcs-nginx > /dev/null 2>&1 || true
	@docker rmi srcs-wordpress > /dev/null 2>&1 || true
	@docker rmi srcs-mariadb > /dev/null 2>&1 || true
	@docker rmi srcs-redis > /dev/null 2>&1 || true
	@docker rmi srcs-vsftpd > /dev/null 2>&1 || true
	@docker rmi srcs-adminer > /dev/null 2>&1 || true
	@docker rmi srcs-portainer > /dev/null 2>&1 || true

# Remove volumes
_remove_volumes:
	@rm -rf ~/data/mariadb ~/data/wordpress > /dev/null 2>&1 || true
	@docker volume rm srcs_db-data > /dev/null 2>&1 || true
	@docker volume rm srcs_wp-data > /dev/null 2>&1 || true

# Remove network
_remove_network:
	@docker network rm inception > /dev/null 2>&1 || true


#	╔════════════════════════════════════╗
#	║          EVALUATION RULES          ║
#	╚════════════════════════════════════╝


# Remove everything before a evaluation
evaluation:
	@docker compose -f $(COMPOSE_FILE) down || exit 1
	@printf "\nplease wait...\n"
	@rm -rf ~/data/mariadb ~/data/wordpress > /dev/null 2>&1 || true
	@docker volume rm srcs_db-data > /dev/null 2>&1 || true
	@docker volume rm srcs_wp-data > /dev/null 2>&1 || true
	@docker stop $(shell docker ps -qa) > /dev/null 2>&1 || true
	@docker rm $(shell docker ps -qa) > /dev/null 2>&1 || true
	@docker rmi -f $(shell docker images -qa) > /dev/null 2>&1 || true
	@docker volume rm $(shell docker volume ls -q) > /dev/null 2>&1 || true
	@docker network rm $(shell docker network ls -q) > /dev/null 2>&1 || true
	@printf "\033[1A\r%50s\r ✔ Ready for evaluation\n\n"


#	╔═══════════════════════════════════╗
#	║               PHONY               ║
#	╚═══════════════════════════════════╝


.PHONY: all up down restart
.PHONY: build rebuild
.PHONY: clean iclean vclean nclean fclean fcclean
.PHONY: _remove_volumes _remove_images _remove_network
.PHONY: evaluation
