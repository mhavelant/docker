FROM ubuntu:xenial
MAINTAINER Wodby <admin@wodby.com>

# Install packages
RUN apt-get -y update \
    && apt-get -y install \
        pkg-config \
        unzip \ 
        #libressl \
        ca-certificates \
        openssh-client \
        rsync \
        git \
        curl \
        wget \
        gzip \
        patch \
        perl \
        #pcre \ below one is new
        pcre2-utils \
        #imap \
        imagemagick \
        mariadb-client \

        # Temp packages
        #build-base \ below one is new
        build-essential \
        autoconf \
        libtool \
        php7.0-dev \
        #pcre-dev \
        #imagemagick-dev \ below one is new
        imagemagick \

        # PHP packages
        php7.0 \
        php7.0-fpm \
        php7.0-opcache \
        #php7.0-session \
        php7.0-dom \
        # new addition
        php7.0-common \
        # new addition
        php7.0-cli \
        php7.0-xml \
        php7.0-xmlreader \
        php7.0-ctype \
        php7.0-ftp \
        php7.0-gd \
        php7.0-json \
        php7.0-posix \
        php7.0-curl \
        php7.0-pdo \
        #php7.0-pdo_mysql \
        php7.0-sockets \
        #php7.0-zlib \
        php7.0-mcrypt \
        php7.0-mysqli \
        php7.0-sqlite3 \
        php7.0-bz2 \
        php7.0-phar \
        #php7.0-openssl \
        php7.0-posix \
        php7.0-zip \
        php7.0-calendar \
        php7.0-iconv \
        php7.0-imap \
        php7.0-soap \
        php7.0-dev \
        #php7.0-pear \
        #php7.0-redis \
        php7.0-mbstring \
        #php7.0-xdebug \
        php7.0-exif \
        php7.0-xsl \
        php7.0-ldap \
        php7.0-bcmath \
        #php7.0-memcached \

        && \

    # Create symlinks for backward compatibility
    ln -sf /usr/bin/php7.0 /usr/bin/php && \
    ln -sf /usr/sbin/php-fpm7 /usr/bin/php-fpm && \

    mkdir -p /etc/php/7.0/conf.d && \

    # Install imagick
    sed -ie 's/-n//g' /usr/bin/pecl && \
    yes | pecl install imagick && \
    echo 'extension=imagick.so' > /etc/php/7.0/conf.d/imagick.ini && \

    # Install uploadprogess
    cd /tmp/ && wget https://github.com/Jan-E/uploadprogress/archive/master.zip && \
    unzip master.zip && \
    cd uploadprogress-master/ && \
    phpize7 && ./configure --with-php-config=/usr/bin/php-config7 && \
    make && make install && \
    echo 'extension=uploadprogress.so' > /etc/php/7.0/conf.d/20_uploadprogress.ini && \
    cd .. && rm -rf ./master.zip ./uploadprogress-master && \

    # Disable Xdebug
    rm /etc/php7.0/conf.d/xdebug.ini && \

    # Install composer
    curl -sS https://getcomposer.org/installer | php7.0 -- --install-dir=/usr/local/bin --filename=composer && \

    # Install PHPUnit
    curl -sSL https://phar.phpunit.de/phpunit.phar -o phpunit.phar && \
        chmod +x phpunit.phar && \
        mv phpunit.phar /usr/local/bin/phpunit && \

    # Install drush
    php -r "readfile('https://s3.amazonaws.com/files.drush.org/drush.phar');" > /usr/local/bin/drush && \
    chmod +x /usr/local/bin/drush && \

    # Install Drupal Console
    curl https://drupalconsole.com/installer -o /usr/local/bin/drupal && \
    chmod +x /usr/local/bin/drupal && \

    # Cleanup
    apt-get purge \
        *-dev \
        build-base \
        autoconf \
        libtool \
        && \

    rm -rf \
        /usr/include/php \
        /usr/lib/php/build \
        /var/cache/apt/* \
        /tmp/* \
        /root/.composer

# Configure php.ini
RUN sed -i \
        -e "s/^expose_php.*/expose_php = Off/" \
        -e "s/^;date.timezone.*/date.timezone = UTC/" \
        -e "s/^memory_limit.*/memory_limit = -1/" \
        -e "s/^max_execution_time.*/max_execution_time = 300/" \
        -e "s/^post_max_size.*/post_max_size = 512M/" \
        -e "s/^upload_max_filesize.*/upload_max_filesize = 512M/" \
        -e "s/^error_reporting.*/error_reporting = E_ALL/" \
        -e "s/^display_errors.*/display_errors = On/" \
        -e "s/^display_startup_errors.*/display_startup_errors = On/" \
        -e "s/^track_errors.*/track_errors = On/" \
        -e "s/^mysqlnd.collect  _memory_statistics.*/mysqlnd.collect_memory_statistics = On/" \
        /etc/php/7.0/php.ini && \

    echo "error_log = \"/proc/self/fd/2\"" | tee -a /etc/php/7.0/php.ini

# Copy PHP configs
COPY 00_opcache.ini /etc/php/7.0/conf.d/
COPY 00_xdebug.ini /etc/php/7.0/conf.d/
COPY php-fpm.conf /etc/php/7.0/

# Add default drush aliases
RUN mkdir -p /etc/drush/site-aliases
COPY default.aliases.drushrc.php /etc/drush/site-aliases/

# Create user www-data
RUN addgroup -g 82 -S www-data && \
	adduser -u 82 -D -S -G www-data www-data

# Create work dir
RUN mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www

WORKDIR /var/www/html
VOLUME /var/www/html
EXPOSE 9000

# Init www-data user
USER www-data
RUN composer global require hirak/prestissimo:^0.3 --optimize-autoloader && \
    rm -rf ~/.composer/.cache && \
    drupal init --override

USER root
COPY docker-entrypoint.sh /usr/local/bin/
CMD docker-entrypoint.sh
