SHELL=/bin/bash

## FOLDERS ##

SRCS				+= srcs/
REQ_DIR 			+= $(SRCS)/requirements/

MARIADB_DIR			= $(REQ_DIR)/mariadb/
NGINX_DIR			= $(REQ_DIR)/nginx/
TOOLS_DIR			= $(REQ_DIR)/tools/
WORDPRESS_DIR		= $(REQ_DIR)/wordpress/

## IMAGES ##

RM_IMG 				:= if [ $$(docker images -q) ]; then docker rmi $$(docker images -q); fi

all:
	cd $(SRCS); docker-compose build
	cd $(SRCS); docker-compose up -d

stop:
	cd $(SRCS); docker-compose down

clean: stop
	cd $(NGINX_FOLDER); $(RM_IMG)

fclean: clean

re: clean
	$(MAKE)

.SILENT:
.PHONY: