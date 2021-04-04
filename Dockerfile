#installed image from dockerhub
FROM	debian:buster

#creator 'n' owner of server
LABEL maintainer="sbeneke@student.21-school.ru"

#install instruments
RUN apt-get update && apt-get install -y \
    libnss3-tools \
    nginx \
    mariadb-server \
    php-mysql \
    php-mbstring \
    openssl \
    vim \
    wget \
    php7.3-fpm

#create ssl key 
RUN openssl req -x509 -newkey rsa:2048 -nodes -sha256 -days 365 -keyout server.key -out server.crt -subj "/CN=localhost" && \
    mkdir /etc/nginx/ssl && \
    mv server.key /etc/nginx/ssl && \
    mv server.crt /etc/nginx/ssl && \
    chmod 600 /etc/nginx/ssl/*

#then working in following direction 
WORKDIR /var/www/html/

#install phpmyadmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz && \
    tar -xvf phpMyAdmin-5.0.2-all-languages.tar.gz && \
    rm -rf phpMyAdmin-5.0.2-all-languages.tar.gz && \
    mv phpMyAdmin-5.0.2-all-languages phpmyadmin

#install wordpress
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xvf latest.tar.gz && \
    rm -rf latest.tar.gz

#give rights to page files to nginx user-groups
RUN chown -R www-data:www-data /var/www/html

#copy my configuration files into container 
COPY ./srcs/* ./
COPY /tmp/*.conf /tmp/

#working with http 'n' https
EXPOSE 80 443

#run file run.sh
CMD bash run.sh