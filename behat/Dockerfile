FROM php:7.0.30-cli-alpine3.7

LABEL version="1.0.0"
LABEL description="Customized version from the bergil/docker-behat repo."
LABEL maintainer="mhavelant@brainsum.com"

ENV PATH="/var/www/.composer/vendor/bin:$PATH" \
    PHP_VERSION=7.0

RUN apk add --no-cache zlib-dev \
    && rm -fr /var/cache/apk/* \
    && docker-php-ext-install zip \
    && curl -sS https://getcomposer.org/installer | php -- --filename=composer \
    --install-dir=/usr/bin \
    && composer global require "hirak/prestissimo:^0.3" --optimize-autoloader \
    && rm -rf ~/.composer/.cache

# Add files and folders to container.
ADD ["composer.json", "entrypoint.sh", "/srv/"]
WORKDIR /srv

# Install and initialize Behat, create folder for artifacts.
RUN composer install \
    && bin/behat --init \
    && mkdir -p artifacts

ENTRYPOINT ["/srv/entrypoint.sh"]
