#!/bin/sh

chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

echo "Creating database"
tfile="$(mktemp)"
if [ ! -f "$tfile" ]; then
	return 1
fi

# Store commands into a temporary file
cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
DROP DATABASE IF EXISTS test;
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO 'user'@'%';
FLUSH PRIVILEGES;
EOF

# Initialize mysqld
/usr/sbin/mysqld --user=mysql --bootstrap --verbose --skip-name-resolve --skip-networking=0 < "$tfile"
cat $tfile
rm -f "$tfile"

# Keep the MariaDB server running in the foreground
exec /usr/sbin/mysqld --user=mysql --console --skip-name-resolve --skip-networking=0 $@

