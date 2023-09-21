FROM debian:bullseye

# Install MariaDB server and client
RUN apt-get update && apt-get upgrade && \
    apt-get install mariadb-server -y && \
    rm -rf /var/lib/apt/lists/*

# Give permissions on specific folders 

RUN mkdir -p /var/run/mysqld \
&& chown -R mysql:mysql /var/run/mysqld \
&& chmod 777 /var/run/mysqld

# Set the working directory inside the container
WORKDIR /etc/mysql/

# Copy the MariaDB configuration
COPY ./conf/my.cnf /etc/mysql/my.cnf

# Copy the init DB script
COPY /tools/init_db.sh /etc/mysql/

# Grant execute permissions to the init DB script
RUN chmod +x /etc/mysql/init_db.sh

# Expose the default MariaDB port
EXPOSE 3306

# Start the MariaDB server on container startup
ENTRYPOINT [ "/etc/mysql/init_db.sh" ]
 