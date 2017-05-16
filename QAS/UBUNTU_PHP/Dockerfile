# FROM ubuntu:xenial
# Better:
FROM phusion/baseimage:0.9.19
# Might be smaller:
# FROM debian:jessie

MAINTAINER MHavelant <mhavelant@brainsum.com>

# This Dockerfile has been copied from: https://github.com/Wodby/drupal-php/tree/master/7.0

# Before the refactor:   wodby-on-baseimage      latest              104e1e8495d5        35 minutes ago      837.5 MB
# After the refactor:    wodby-on-baseimage      latest              e09f84d187db        35 seconds ago      664.2 MB
# After the refactor#2:  wodby-on-baseimage      latest              72fa45aa0d74        16 seconds ago      664.1 MB
# Refactor#3             drupal_php              latest              d10ab6e5dbe0        3 minutes ago       583.4 MB
# Refactor#4             drupal_php              latest              6097933d9482        4 minutes ago       572.6 MB

# Notes:
# Ref3: Wget phantomjs instead of npm install
# Refactor#4 | Lots of doc rm-s

# build with:
# docker build -t drupal_php .
# docker build -t drupal_php . --no-cache --rm -t havelantmate/drupal_php:Backstop2.6.13-SlimerJS

# lint with:
# ~/www/docker/node_modules/dockerfilelint/bin/dockerfilelint ~/www/docker/QAS/UBUNTU_PHP/Dockerfile

# After build cleanup
# docker rmi $(docker images -f "dangling=true" -q) && docker volume rm $(docker volume ls -qf dangling=true)

# Push to docker hub
#   docker login
#   docker images (get the image hash)
#   Optionally, but build is tagging it: docker tag <hash> havelantmate/drupal_php:<whatever>
#   docker push havelantmate/drupal_php

# @todo:
# cannot load Zend OPcache - it was already loaded
# php_1      | [16-Nov-2016 10:29:54 UTC] PHP Warning:  PHP Startup: Unable to load dynamic library '/usr/lib/php/20151012/imagick.so' - /usr/lib/php/20151012/imagick.so: cannot open shared object file: No such file or directory in Unknown on line 0

# @todo:
# PHP Startup: Unable to load dynamic library '/usr/lib/php/20151012/imagick.so' - /usr/lib/php/20151012/imagick.so: cannot open shared object file: No such file or directory in <b>Unknown</b> on line <b>0</b><br />"

# Install packages | 240MB
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get -y update && \
    apt-get -y --no-install-recommends install \
        pkg-config \
        fontconfig \
        unzip \
        bzip2 \
        ca-certificates \
        openssh-client \
        git \
        curl \
        wget \
        gzip \
        patch \
        perl \
        libpcre2-dev \
        imagemagick \
        nodejs \

        # Temp packages
        build-essential \
        autoconf \
        libtool \
        php7.0-dev \

        # PHP packages
        php7.0 \
        php7.0-fpm \
        php7.0-opcache \
        php7.0-dom \
        php7.0-common \
        php7.0-xml \
        php7.0-xmlreader \
        php7.0-ctype \
        php7.0-ftp \
        php7.0-gd \
        php7.0-json \
        php7.0-posix \
        php7.0-curl \
        php7.0-pdo \
        php7.0-sockets \
        php7.0-mcrypt \
        php7.0-mysqli \
        php7.0-sqlite3 \
        php7.0-bz2 \
        php7.0-phar \
        php7.0-posix \
        php7.0-zip \
        php7.0-calendar \
        php7.0-iconv \
        php7.0-imap \
        php7.0-soap \
        php7.0-mbstring \
        php7.0-exif \
        php7.0-xsl \
        php7.0-ldap \
        php7.0-bcmath \
        php-memcached \
        php-pear \
        php-redis \
        php-xdebug \
        rsync \
        mariadb-client \

        # Stuff for SlimerJS.
        firefox=45.* \
        xvfb \
        && \

    ln -sf /usr/bin/php7.0 /usr/bin/php && \
    ln -sf /usr/sbin/php-fpm7.0 /usr/bin/php-fpm && \

    mkdir -p /etc/php/7.0/fpm/conf.d && \

    # Install imagick
    sed -ie 's/-n//g' /usr/bin/pecl && \
    yes | pecl install imagick && \
    echo 'extension=imagick.so' > /etc/php/7.0/fpm/conf.d/imagick.ini && \

    # Install uploadprogess
    cd /tmp/ && wget https://github.com/Jan-E/uploadprogress/archive/master.zip && \
    unzip master.zip && \
    cd uploadprogress-master/ && \
    phpize && ./configure --with-php-config=/usr/bin/php-config && \
    make && make install && \
    echo 'extension=uploadprogress.so' > /etc/php/7.0/fpm/conf.d/20_uploadprogress.ini && \
    cd .. && rm -rf ./master.zip ./uploadprogress-master && \

    # Disable Xdebug
    #rm /etc/php7.0/fpm/conf.d/xdebug.ini && \

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
    rm -rf \
        /var/lib/apt/lists/* \
        /var/cache/apt/* \
        /usr/include/php \
        /usr/lib/php/build && \
    # Cleanupetc
    apt-get -y purge \
        *-dev \
        build-essential \
        autoconf \
        libtool \
        && \

    apt-get -y clean && \
    apt-get -y autoclean && \
    apt-get -y autoremove && \

    # Configure php.ini
    sed -i \
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
        /etc/php/7.0/fpm/php.ini && \

    echo "error_log = \"/proc/self/fd/2\"" | tee -a /etc/php/7.0/fpm/php.ini

# @todo: Maybe expldoe this into 2 dockerfiles? One base and one QAS?
# Add default drush aliases | 186MB
RUN mkdir -p /etc/drush/site-aliases && \
    mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www && \
    # Install PhantomJS through zip. 66MB
    cd /usr/local/share && \
    wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 && \
    tar xjf phantomjs-2.1.1-linux-x86_64.tar.bz2 && \
    rm phantomjs-2.1.1-linux-x86_64.tar.bz2 && \
    ln -sf /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs && \
    ln -sf /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/phantomjs && \
    # Install CasperJS through npm. 2.3MB
    ln -sf /usr/bin/python3.5 /usr/bin/python && \
    npm install -g casperjs  && \
    # Install SlimerJS through npm.
    npm install -g slimerjs  && \
    # Disable strict JS so console doesn't get flooded with useless messages.
    sed -ie 's/"javascript.options.strict", true/"javascript.options.strict", false/g' /usr/lib/node_modules/slimerjs/src/defaults/preferences/prefs.js && \
    # Install BackstopJS through npm. 37MB
    npm install -g backstopjs && \
    # Cleanup
    cd /usr/local/share/phantomjs-2.1.1-linux-x86_64 && \
    rm -rf \
        ChangeLog \
        LICENSE.BSD \
        README.md \
        examples \
        third-party.txt && \
    cd /usr/lib/node_modules/backstopjs && \
    rm -rf \
        README.md \
        backstop.json \
        backstop_production.json \
        bower.json \
        LICENSE \
        index.html \
        backstop_data \
        homepage \
        test \
        examples && \
    cd /usr/lib/node_modules/casperjs && \
    rm -rf \
        CHANGELOG.md \
        CONTRIBUTING.md \
        CONTRIBUTORS.md \
        LICENSE.md \
        Makefile \
        README.md \
        casperjs.gemspec \
        docs \
        samples \
        tests && \
    npm cache -g clean && \
    chown www-data:www-data /usr/lib/node_modules -R && \
    rm -rf \
        /tmp/* \
        /root/.composer \
        /var/tmp/*

COPY default.aliases.drushrc.php /etc/drush/site-aliases/
COPY 00_opcache.ini 00_xdebug.ini /etc/php/7.0/fpm/conf.d/
COPY php-fpm.conf /etc/php/7.0/fpm/

# Ubuntu base image = www-data already there with UID 33
# Create user www-data
#RUN addgroup --gid 82 --system www-data && \
#	adduser --uid 82 --no-create-home --system --gid 82 www-data

WORKDIR /var/www/html
VOLUME /var/www/html
EXPOSE 9000

# Init www-data user
USER www-data

# Composer stuff | 13MB
RUN composer global require hirak/prestissimo:^0.3.3 --optimize-autoloader && \
    rm -rf ~/.composer/.cache

USER root
COPY docker-entrypoint.sh /usr/local/bin/
ENV DISPLAY=localhost:0.0
ENTRYPOINT docker-entrypoint.sh