FROM php:8.2-apache

RUN docker-php-ext-install pdo pdo_mysql && \
    apt-get update && apt-get install -y libzip-dev && \
    docker-php-ext-install zip && \
    a2enmod rewrite

COPY ./ /var/www/html/

RUN chown -R www-data:www-data /var/www/html/ && chmod -R 755 /var/www/html/

EXPOSE 80