SHELL=/bin/bash

## CONTAINERS ##

NGINX				= nginx
WORDPRESS			= wordpress
MARIADB				= mariadb

## FOLDERS ##

SRCS				+= srcs/
REQ_DIR 			+= $(SRCS)/requirements/

MARIADB_DIR			= $(REQ_DIR)/mariadb/
NGINX_DIR			= $(REQ_DIR)/nginx/
TOOLS_DIR			= $(REQ_DIR)/tools/
WORDPRESS_DIR		= $(REQ_DIR)/wordpress/

## VOLUMES ##

CREATE_VOLUMES		= sudo mkdir -p ~/data/wordpress ~/data/mariadb
RM_VOLUMES			= sudo rm -fr ~/data/wordpress ~/data/mariadb

## IMAGES ##

RM_IMG 				:= if [ "$$(docker images -q)" ]; then docker rmi $$(docker images -q) -f; fi
RM_VOL 				:= if [ "$$(docker volume ls -q)" ]; then docker volume rm $$(docker volume ls -q); fi
RM_ALL 				:= docker system prune -af

all:
	$(CREATE_VOLUMES)
	cd $(SRCS); docker-compose build
	cd $(SRCS); docker-compose up -d

up:
	cd $(SRCS); docker-compose up -d

stop:
	docker stop $(NGINX)
	docker stop $(WORDPRESS)
	docker stop $(MARIADB)
	cd $(SRCS); docker-compose down

clean: stop
	cd $(NGINX_DIR); $(RM_IMG)
	cd $(NGINX_DIR); $(RM_VOL)
	cd $(MARIADB_DIR); $(RM_IMG)
	cd $(MARIADB_DIR); $(RM_VOL)
	cd $(WORDPRESS_DIR); $(RM_IMG)
	cd $(WORDPRESS_DIR); $(RM_VOL)

fclean: clean
	cd $(NGINX_DIR); $(RM_ALL)
	cd $(MARIADB_DIR); $(RM_ALL)
	cd $(WORDPRESS_DIR); $(RM_ALL)
	$(RM_VOLUMES)

re: fclean
	$(MAKE)

.SILENT:
.PHONY:
