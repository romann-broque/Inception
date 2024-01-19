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

## ENV ##

ENV_FILE			:= .env

ENV_VAR_LIST	+= WP_ADMIN_USER
ENV_VAR_LIST	+= WP_ADMIN_EMAIL
ENV_VAR_LIST	+= WP_ADMIN_PASSWORD
ENV_VAR_LIST	+= WP_SUBSCRIBER_USER
ENV_VAR_LIST	+= WP_SUBSCRIBER_EMAIL
ENV_VAR_LIST	+= WP_SUBSCRIBER_PASSWORD
ENV_VAR_LIST	+= MYSQL_ROOT_PASSWORD
ENV_VAR_LIST	+= MYSQL_USER
ENV_VAR_LIST	+= MYSQL_PASSWORD

ENV_EXAMPLE			:= "\
\nSome variables are missing.\
A $(ENV_FILE) file is supposed to be in $(SRCS).\
\nIt should look like this:\n \
\n---WP SETUP---\n\
\n\
WP_ADMIN_USER=\n\
WP_ADMIN_EMAIL=\n\
WP_ADMIN_PASSWORD=\n\
WP_SUBSCRIBER_USER=\n\
WP_SUBSCRIBER_EMAIL=\n\
WP_SUBSCRIBER_PASSWORD=\n\
\n---MYSQL SETUP---\n\
\n\
MYSQL_ROOT_PASSWORD=\n\
MYSQL_USER=\n\
MYSQL_PASSWORD=\n\
\n----DONT FORGET TO SET VALUES----\n"

MISSING_VAR_HELP 	:= Environment variables are missing, type "make help"

## CHECK IF ENV IS COMPLETE ##

include $(SRCS)/$(ENV_FILE)

CHECK_ENV = true
ifeq ($(words $(MAKECMDGOALS)),1)
   ifeq ($(filter help,$(MAKECMDGOALS)),help)
       CHECK_ENV = false
   endif
endif

ifeq ($(CHECK_ENV), true)
check_defined = \
	$(strip $(foreach 1,$1, \
		$(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
	$(if $(value $1),, \
		$(error Undefined $1$(if $2, ($2))))

$(call check_defined, $(ENV_VAR_LIST), $(MISSING_VAR_HELP))
endif

## COMMANDS ##

BUILD				:= docker-compose build
UP					:= docker-compose up -d
STOP				:= docker-compose stop
RESTART				:= docker-compose restart
LOG					:= docker-compose logs
CREATE_DIR			:= sudo mkdir -p ~/data/wordpress ~/data/mariadb
RM_VOLUMES			:= sudo rm -fr ~/data/wordpress ~/data/mariadb
STOP_CONT			:= if [ "$$(docker ps -q)" ]; then docker stop $$(docker ps -q); fi
RM_IMG 				:= if [ "$$(docker images -q)" ]; then docker rmi $$(docker images -q) -f; fi
RM_VOL 				:= if [ "$$(docker volume ls -q)" ]; then docker volume rm $$(docker volume ls -q); fi
RM_ALL 				:= docker system prune -af
PRINT_ENV_EXAMPLE 	:= echo -e $(ENV_EXAMPLE)

## RULES ##

# Create volumes and start containers
all: .create_volumes build up

# Build containers
build:
	cd $(SRCS); $(BUILD)

# Start containers
up:
	cd $(SRCS); $(UP)

# Restart containers
restart:
	cd $(SRCS); $(RESTART)

# Print logs
log:
	cd $(SRCS); $(LOG)

# Stop containers
stop: .stop_containers

# Remove images and volumes
clean: stop .remove_images .remove_volumes

# Remove all images, volumes, and data
fclean: clean .remove_local_dirs .remove_cache

# Rebuild everything
re: fclean all

# Print help
help:
	$(PRINT_ENV_EXAMPLE)

.create_volumes:
	$(CREATE_DIR)

.stop_containers:
	cd $(SRCS); $(STOP)

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

.remove_cache:
	$(RM_ALL)

.SILENT:
.PHONY:
