FROM php:8.1.0-fpm-alpine3.14

ARG UID
RUN apk --update add shadow
ARG user
ARG uid
#RUN usermod -u $UID 1000 && groupmod -g $UID 1000
RUN apk --update add sudo
RUN echo "www-data ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN apk --update add composer
RUN docker-php-ext-install pdo_mysql
RUN apk add --update npm
RUN apk add --update make
RUN apk add --no-cache \
	$PHPIZE_DEPS

#RUN pecl install swoole

#RUN docker-php-ext-enable swoole

#RUN docker-php-ext-install pcntl

EXPOSE 8000

# ENTRYPOINT php artisan octane:start --host 0.0.0.0 --watch

# ENTRYPOINT tail -f /dev/null

RUN cd /usr/local/etc/php/conf.d/ && \
  echo 'upload_max_filesize = -60M' >> /usr/local/etc/php/conf.d/docker-php-ram-limit.ini
RUN cd /usr/local/etc/php/conf.d/ && \
  echo 'post_max_size = -60M' >> /usr/local/etc/php/conf.d/docker-php-ram-limit.ini  

RUN apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev && \
  docker-php-ext-configure gd --with-freetype --with-jpeg NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
  docker-php-ext-install -j$(nproc) gd && \
  apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev

RUN apk add --no-cache zip libzip-dev && docker-php-ext-install zip

#ENTRYPOINT php artisan serve --host 0.0.0.0
