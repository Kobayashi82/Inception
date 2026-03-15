# Debian image
FROM debian:bullseye

# Install MariaDB
RUN apt-get update && apt-get install -y mariadb-server mariadb-client

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# MariaDB Settings
RUN mkdir -p /var/run/mysqld
RUN chmod 777 /var/run/mysqld
RUN chown -R mysql:mysql /var/lib/mysql
RUN mysql_install_db --user=mysql

# Copy config script
COPY conf/config.sh /usr/local/bin/config_db.sh
RUN chmod +x /usr/local/bin/config_db.sh

# Execute config script
ENTRYPOINT ["/usr/local/bin/config_db.sh"]

EXPOSE 3306

# Useful commands:
#
#	mariadb/mysql -u [user] -p						Login to MariaDB
#	SHOW DATABASES;									Show all databases
#	USE [database_name];							Switch to a specific database
#	SHOW TABLES;									List all tables in the selected database
#	DESCRIBE [table_name];							Show the structure of a table (columns and types)
#	SHOW COLUMNS FROM [table_name];					Show columns and their details from a table
#	SELECT * FROM [table_name];						Show all rows and columns from a table
#	CREATE DATABASE [database_name];				Create a new database
#	DROP DATABASE [database_name];					Delete a database and all of its data
#	SELECT User, Host FROM mysql.user;				List all users and their permitted hosts
#	EXIT;											Exit MariaDB
