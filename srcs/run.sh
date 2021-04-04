#!/bin/sh

bash change_autoindex.sh

service php7.3-fpm start

#create database
service mysql start
echo "CREATE DATABASE wordpress;" | mysql -u root                    
echo "CREATE USER 'sbeneke'@'localhost';" | mysql -u root --skip-password          
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'sbeneke'@'localhost';" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password

nginx -g 'daemon off;'