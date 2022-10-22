#FROM php:7.4

#RUN apt-get update -y && apt-get install -y openssl zip unzip git && apt-get install -y libonig-dev
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
#RUN docker-php-ext-install pdo mbstring pdo_mysql

#WORKDIR /app
#COPY . .
#RUN composer install

#CMD php artisan serve --host=0.0.0.0
#EXPOSE 8000



# https://github.com/k90mirzaei/laravel9-docker - чостично брал от сюда, частично от Антонио Папа
FROM php:8.1-fpm

#RUN apt-get update -y && apt-get install -y openssl zip unzip git && apt-get install -y libonig-dev
RUN apt-get update -y && apt-get install -y \
    openssl \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Postgre PDO
RUN apt-get update && apt-get install -y libpq-dev && docker-php-ext-install pdo pdo_pgsql

# Var 1: Install Composer using curl
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Var 2: Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

WORKDIR /var/www/html

COPY . /var/www/html

RUN composer install

CMD php artisan serve --host=0.0.0.0

#EXPOSE 9000
