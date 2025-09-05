FROM php:8.3-apache-bookworm


RUN docker-php-ext-install pdo_mysql

RUN apt-get update && apt-get install -y \
    libicu-dev \
    && openssl \
    && a2enmod ssl\
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && rm -rf /var/lib/apt/lists/*

# Installer l'extension zip
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    && docker-php-ext-install zip \
    && rm -rf /var/lib/apt/lists/*

# install nodejs & npm
RUN apt-get update && apt-get install -y \
    nodejs \
    npm \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Symfony CLI 
RUN curl -sS https://get.symfony.com/cli/installer | bash \
    && mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

RUN a2enmod rewrite

COPY ./docker.sh /var/opt/docker.sh
COPY ./apache.conf /etc/apache2/sites-available/000-default.conf
COPY . /var/www/html


# Donner les bonnes permissions et propriétaires
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html



RUN chmod +x /var/opt/docker.sh
ENTRYPOINT ["/var/opt/docker.sh"]

WORKDIR /var/www/html

EXPOSE 80