SHELL=/bin/bash

WORK_DIR="requirements"

MARIADB_FOLDER=$(WORK_DIR)/mariadb/
NGINX_FOLDER=$(WORK_DIR)/nginx/
TOOLS_FOLDER=$(WORK_DIR)/tools/
WORDPRESS_FOLDER=$(WORK_DIR)/wordpress/

all:
	docker-compose build
	docker-compose up -d

stop:
	docker-compose down

clean: stop
	cd $(NGINX_FOLDER); docker rmi $$(docker images -q) -f

fclean: clean

re: clean
	$(MAKE)

.SILENT:
.PHONY: