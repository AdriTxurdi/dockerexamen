# Imagen de dockerhub
FROM php:8.1.0-apache-buster

RUN a2enmod rewrite

# Instalacion de laravel y sus dependencias
RUN apt-get update && apt-get install -y \
        zlib1g-dev \
        libicu-dev \
        libxml2-dev \
        libpq-dev \
        libzip-dev
        #&& docker-php-ext-install pdo pdo_mysql zip intl xmlrpc soap opcache \
        #&& docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd


RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && docker-php-ext-install pdo_pgsql pgsql

RUN apt-get update -y
#Instalacion composer (Instalar composer manualmente dentro de un docker es un infierno, por lo cual, cogemos la carpeta composer de una imagen oficial y la copiamos a nuestro docker)
COPY --from=composer /usr/bin/composer /usr/bin/composer



ENV COMPOSER_ALLOW_SUPERUSER 1

#Descargamos GIT y Cambiamos de directorio
RUN apt update && apt install -y git 
WORKDIR /var/www/html
#Variable Para Repositorio GIT
ENV GIT_LINK=https://github.com/AdriTxurdi/dockerexamen.git
ENV GIT_REP=main
#Clonación del repositorio GIT
RUN git clone -b ${GIT_REP} ${GIT_LINK} .
#Cambio de Permisos
RUN chown -R www-data:www-data /var/www/html

