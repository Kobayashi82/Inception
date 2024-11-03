
# Project name
NAME	= inception

GREEN	= \033[0;32m
NC		= \033[0m

# Path to the docker-compose.yml file
COMPOSE_FILE = ./srcs/docker-compose.yml

all: up

# Starts the containers in detached mode
up:
	@mkdir -p ~/data/mariadb ~/data/wordpress
	@docker compose -f $(COMPOSE_FILE) up -d || exit 1
	@printf "\n"

# Stops and removes the containers
down:
	@docker compose -f $(COMPOSE_FILE) down || exit 1
	@printf "\n"

# Restarts the containers
restart:
	@mkdir -p ~/data/mariadb ~/data/wordpress
	@docker compose -f $(COMPOSE_FILE) down || exit 1
	@docker compose -f $(COMPOSE_FILE) up -d || exit 1
	@printf "\n"

# Builds the containers
build:
	@mkdir -p ~/data/mariadb ~/data/wordpress
	@docker compose -f $(COMPOSE_FILE) down || exit 1
	@docker compose -f $(COMPOSE_FILE) build || exit 1
	@printf "\n ✔ Containers\t\t$(GREEN)Built$(NC)\n\n"

# Rebuilds the containers
rebuild:
	@mkdir -p ~/data/mariadb ~/data/wordpress
	@docker compose -f $(COMPOSE_FILE) down || exit 1
	@docker compose -f $(COMPOSE_FILE) build --no-cache || exit 1
	@printf "\n ✔ Containers\t\t$(GREEN)Rebuilt$(NC)\n\n"

# Removes containers and network
clean:
	@docker compose -f $(COMPOSE_FILE) down || exit 1
	@printf "\nplease wait...\n"
	@docker rmi srcs-nginx > /dev/null 2>&1 || true
	@docker rmi srcs-wordpress > /dev/null 2>&1 || true
	@docker rmi srcs-mariadb > /dev/null 2>&1 || true
	@docker rmi srcs-redis > /dev/null 2>&1 || true
	@docker rmi srcs-vsftpd > /dev/null 2>&1 || true
	@docker rmi srcs-adminer > /dev/null 2>&1 || true
	@docker rmi srcs-portainer > /dev/null 2>&1 || true
	@printf "\033[1A\r%50s\r ✔ Containers\t\t$(GREEN)Removed$(NC)\n"
	@printf " ✔ Network\t\t$(GREEN)Removed$(NC)\n\n"

# Removes volumes
vclean:
	@docker compose -f $(COMPOSE_FILE) down || exit 1
	@printf "\nplease wait...\n"
	@rm -rf ~/data/mariadb ~/data/wordpress > /dev/null 2>&1
	@docker volume rm srcs_db-data > /dev/null 2>&1 || true
	@docker volume rm srcs_wp-data > /dev/null 2>&1 || true
	@printf "\033[1A\r%50s\r ✔ Volumes\t\t$(GREEN)Removed$(NC)\n\n"

# Removes containers, images, volumes and network
fclean:
	@docker compose -f $(COMPOSE_FILE) down || exit 1
	@printf "\nplease wait...\n"
	@rm -rf ~/data/mariadb ~/data/wordpress > /dev/null 2>&1
	@docker volume rm srcs_db-data > /dev/null 2>&1 || true
	@docker volume rm srcs_wp-data > /dev/null 2>&1 || true
	@docker rmi srcs-nginx > /dev/null 2>&1 || true
	@docker rmi srcs-wordpress > /dev/null 2>&1 || true
	@docker rmi srcs-mariadb > /dev/null 2>&1 || true
	@docker rmi srcs-redis > /dev/null 2>&1 || true
	@docker rmi srcs-vsftpd > /dev/null 2>&1 || true
	@docker rmi srcs-adminer > /dev/null 2>&1 || true
	@docker rmi srcs-portainer > /dev/null 2>&1 || true
	@printf "\033[1A\r%50s\r ✔ Containers\t\t$(GREEN)Removed$(NC)\n"
	@printf " ✔ Images\t\t$(GREEN)Removed$(NC)\n"
	@printf " ✔ Volumes\t\t$(GREEN)Removed$(NC)\n"
	@printf " ✔ Network\t\t$(GREEN)Removed$(NC)\n\n"

# Removes containers, images, volumes, network and cache
fcclean:
	@docker compose -f $(COMPOSE_FILE) down || exit 1
	@printf "\nplease wait...\n"
	@docker system prune -a --volumes -f > /dev/null 2>&1
	@rm -rf ~/data/mariadb ~/data/wordpress > /dev/null 2>&1
	@docker volume rm srcs_db-data > /dev/null 2>&1 || true
	@docker volume rm srcs_wp-data > /dev/null 2>&1 || true
	@docker rmi srcs-nginx > /dev/null 2>&1 || true
	@docker rmi srcs-wordpress > /dev/null 2>&1 || true
	@docker rmi srcs-mariadb > /dev/null 2>&1 || true
	@docker rmi srcs-redis > /dev/null 2>&1 || true
	@docker rmi srcs-vsftpd > /dev/null 2>&1 || true
	@docker rmi srcs-adminer > /dev/null 2>&1 || true
	@docker rmi srcs-portainer > /dev/null 2>&1 || true
	@printf "\033[1A\r%50s\r ✔ Containers\t\t$(GREEN)Removed$(NC)\n"
	@printf " ✔ Images\t\t$(GREEN)Removed$(NC)\n"
	@printf " ✔ Volumes\t\t$(GREEN)Removed$(NC)\n"
	@printf " ✔ Network\t\t$(GREEN)Removed$(NC)\n"
	@printf " ✔ Cache\t\t$(GREEN)Removed$(NC)\n\n"

# Remove everything before a evaluation
evaluation:
	@docker compose -f $(COMPOSE_FILE) down || exit 1
	@printf "\nplease wait...\n"

	@rm -rf ~/data/mariadb ~/data/wordpress > /dev/null 2>&1
	@docker volume rm srcs_db-data > /dev/null 2>&1 || true
	@docker volume rm srcs_wp-data > /dev/null 2>&1 || true

	@docker stop $(shell docker ps -qa) > /dev/null 2>&1 || true
	@docker rm $(shell docker ps -qa) > /dev/null 2>&1 || true
	@docker rmi -f $(shell docker images -qa) > /dev/null 2>&1 || true
	@docker volume rm $(shell docker volume ls -q) > /dev/null 2>&1 || true
	@docker network rm $(shell docker network ls -q) > /dev/null 2>&1 || true

	@printf "\033[1A\r%50s\r ✔ Ready for evaluation\n\n"

.PHONY: all up down restart build rebuild clean vclean fclean fcclean evaluation
