## SHELL

SHELL				:= /bin/bash

## CONTAINERS ##

NGINX				:= nginx
WORDPRESS			:= wordpress
MARIADB				:= mariadb

## FOLDERS ##

SRCS				:= srcs/
REQ_DIR 			:= $(SRCS)/requirements/
MARIADB_DIR			:= $(REQ_DIR)/mariadb/
NGINX_DIR			:= $(REQ_DIR)/nginx/
TOOLS_DIR			:= $(REQ_DIR)/tools/
WORDPRESS_DIR		:= $(REQ_DIR)/wordpress/

## VOLUMES ##

VOLUMES				+= ~/data/mariadb
VOLUMES				+= ~/data/wordpress

## COMMANDS ##

CREATE_VOLUMES		:= sudo mkdir -p ~/data/wordpress ~/data/mariadb
RM_VOLUMES			:= sudo rm -fr ~/data/wordpress ~/data/mariadb
STOP_CONT			:= if [ "$$(docker ps -q)" ]; then docker stop $$(docker ps -q); fi
RM_IMG 				:= if [ "$$(docker images -q)" ]; then docker rmi $$(docker images -q) -f; fi
RM_VOL 				:= if [ "$$(docker volume ls -q)" ]; then docker volume rm $$(docker volume ls -q); fi
RM_ALL 				:= docker system prune -af

## RULES ##

# Create volumes and start containers
all: .create_volumes build up

# Build containers
build:
	cd $(SRCS); docker-compose build

# Start containers
up:
	cd $(SRCS); docker-compose up -d

# Restart containers
restart:
	cd $(SRCS); docker-compose restart

# Print logs
log:
	cd $(SRCS); docker logs

# Stop containers and remove volumes
stop: .stop_containers .remove_volumes

# Remove images and volumes
clean: .stop_containers .remove_images .remove_volumes

# Remove all images, volumes, and data
fclean: clean .remove_local_dirs

# Rebuild everything
re: fclean all

.create_volumes:
	$(CREATE_VOLUMES)

.stop_containers:
	$(STOP_CONT);
	cd $(SRCS); docker-compose down

.remove_images:
	cd $(NGINX_DIR); $(RM_IMG)
	cd $(MARIADB_DIR); $(RM_IMG)
	cd $(WORDPRESS_DIR); $(RM_IMG)

.remove_volumes:
	cd $(NGINX_DIR); $(RM_VOL)
	cd $(MARIADB_DIR); $(RM_VOL)
	cd $(WORDPRESS_DIR); $(RM_VOL)

.remove_local_dirs:
	$(RM_VOLUMES)

.SILENT:
.PHONY: all up stop clean fclean re create_volumes start_containers stop_containers remove_images remove_volumes
