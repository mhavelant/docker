FROM alpine:edge

LABEL version="1.3.0"
LABEL description="Customized version from the bergil/docker-behat repo."
LABEL maintainer="mhavelant@brainsum.com"
LABEL "php version"="7.2.7"

ENV PATH="/var/www/.composer/vendor/bin:$PATH"

# Install PHP7 with needed exstentions and composer with hirak/prestissimo.
RUN apk add --no-cache \
        php7 \
        php7-dom \
        php7-curl \
        php7-json \
        php7-phar \
        php7-openssl \
        php7-mbstring \
        php7-ctype \
        php7-pdo_mysql \
        php7-session \
        php7-xml \
        php7-xmlwriter \
        php7-tokenizer \
        php7-zip \
        php7-gd \
        php7-fileinfo \
        php7-imagick \
        curl \
    && rm -fr /var/cache/apk/* \
    && curl -sS https://getcomposer.org/installer | php -- --filename=composer \
    --install-dir=/usr/bin \
    && composer global require "hirak/prestissimo:^0.3" --optimize-autoloader \
    && rm -rf ~/.composer/.cache

# Add files and folders to container.
COPY ["composer.json", "entrypoint.sh", "/srv/"]
WORKDIR /srv

# Install and initialize Behat, create folder for artifacts.
RUN composer install \
    && bin/behat --init \
    && mkdir -p artifacts \
    && mkdir -p src

ENTRYPOINT ["/srv/entrypoint.sh"]
