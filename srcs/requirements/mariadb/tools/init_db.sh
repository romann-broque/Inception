#!/bin/sh

chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql
mkdir -p /run/mysqld

mysql_install_db # --user=root --ldata=/var/lib/mysql

#Check if the database exists

if [ -d "/var/lib/mysql/${MYSQL_DATABASE}" ]
then 

	echo "Database already exists"
else

	echo "MySQL directory not found, creating database '$MYSQL_DATABASE'"
	mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null
	tfile='mktemp'
	# echo "USE mysql;" >> "$tfile"
	# echo "FLUSH PRIVILEGES ;" >> "$tfile"
	echo "GRANT ALL ON *.* TO 'root'@'%' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;" >> "$tfile"
	echo "GRANT ALL ON *.* TO 'root'@'localhost' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;" >> "$tfile"
	echo "SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ;" >> "$tfile"
	echo "DROP DATABASE IF EXISTS test ;" >> "$tfile"
	echo "FLUSH PRIVILEGES ;" >> "$tfile"
	echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> "$tfile"
	echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQK_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> "$tfile"
	echo "Database initialised!"
	mysqld < $tfile
	# mysqld --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < "$tfile"
	rm -f "$tfile"
fi
exec "$@"

# ---------------------

# Set root option so that connexion without root password is not possible

# mysql_secure_installation << _EOF_

# Y
# root4life
# root4life
# Y
# n
# Y
# Y
# _EOF_

#Add a root user on 127.0.0.1 to allow remote connexion 
#Flush privileges allow to your sql tables to be updated automatically when you modify it
#mysql -uroot launch mysql command line client

# echo "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}'; FLUSH PRIVILEGES;" | mysql -uroot

#Create database and user in the database for wordpress

# echo "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE}; GRANT ALL ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}'; FLUSH PRIVILEGES;" | mysql -u root

# echo "------- This is databse configuration ------"
# mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
# mysql -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';"
# mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
# mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
# mysql -e "FLUSH PRIVILEGES;"

#Import database in the mysql command line
# mysql -uroot -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < /usr/local/bin/wordpress.sql

# fi
