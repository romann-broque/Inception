SHELL=/bin/bash

## FOLDERS ##

WORK_DIR=requirements

MARIADB_FOLDER		= $(WORK_DIR)/mariadb/
NGINX_FOLDER		= $(WORK_DIR)/nginx/
TOOLS_FOLDER		= $(WORK_DIR)/tools/
WORDPRESS_FOLDER	= $(WORK_DIR)/wordpress/

## IMAGES ##

RM_IMG 				:= if [ $$(docker images -q) ]; then docker rmi $$(docker images -q); fi

all:
	docker-compose build
	docker-compose up -d

stop:
	docker-compose down

clean: stop
	cd $(NGINX_FOLDER); $(RM_IMG)

fclean: clean

re: clean
	$(MAKE)

.SILENT:
.PHONY: