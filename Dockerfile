FROM php:8.2-apache

# ---- System dependencies ----
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libonig-dev \
    libmagickwand-dev \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# ---- PHP extensions ----
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
        gd \
        pdo_mysql \
        curl \
        mbstring \
        intl \
        gmp \
        xml \
        zip \
        opcache

# ---- Enable Apache modules (BUILD TIME) ----
RUN a2enmod rewrite headers env dir mime ssl

# ---- Copy Nextcloud ----
COPY nextcloud-src/ /var/www/nextcloud/

# ---- Permissions ----
RUN chown -R www-data:www-data /var/www/nextcloud \
    && chmod -R 755 /var/www/nextcloud

WORKDIR /var/www/nextcloud

EXPOSE 80 443
