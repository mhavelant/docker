FROM phusion/baseimage:0.9.22

LABEL maintainer="mhavelant"

LABEL Description="Contains PHP7.0, Node6, Chrome (beta) 62, Firefox 52, SlimerJS 0.10, BackstopJS 3.0, PhantomJS 2.1"

ENV PATH="/var/www/.composer/vendor/bin:$PATH" \
    DISPLAY=localhost:0.0 \
    OS_DISTRO="xenial" \
    NODE_VERSION=node_6.x \
    NODE_ENV=production \
    FIREFOX_VERSION=52.* \
    # For firefox 55+. We could also use slimerjs --headless.
    # @todo: When this works, remove xvfb.
    MOZ_HEADLESS=1 \
    CHROME_STABILITY=stable \
    CHROME_VERSION=62.* \
    PHP_VERSION=7.0 \
    PHANTOMJS_VERSION=2.1.1

# Install packages | 240MB
# curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
RUN curl --silent https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    echo "deb https://deb.nodesource.com/${NODE_VERSION} ${OS_DISTRO} main" | tee /etc/apt/sources.list.d/nodesource.list && \
    echo "deb-src https://deb.nodesource.com/${NODE_VERSION} ${OS_DISTRO} main" | tee -a /etc/apt/sources.list.d/nodesource.list && \

    add-apt-repository ppa:jonathonf/firefox-esr && \

    curl --silent https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \

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
        php${PHP_VERSION}-dev \

        # PHP packages
        php${PHP_VERSION} \
        php${PHP_VERSION}-fpm \
        php${PHP_VERSION}-opcache \
        php${PHP_VERSION}-dom \
        php${PHP_VERSION}-common \
        php${PHP_VERSION}-xml \
        php${PHP_VERSION}-xmlreader \
        php${PHP_VERSION}-ctype \
        php${PHP_VERSION}-ftp \
        php${PHP_VERSION}-gd \
        php${PHP_VERSION}-json \
        php${PHP_VERSION}-posix \
        php${PHP_VERSION}-curl \
        php${PHP_VERSION}-pdo \
        php${PHP_VERSION}-sockets \
        php${PHP_VERSION}-mcrypt \
        php${PHP_VERSION}-mysqli \
        php${PHP_VERSION}-sqlite3 \
        php${PHP_VERSION}-bz2 \
        php${PHP_VERSION}-phar \
        php${PHP_VERSION}-posix \
        php${PHP_VERSION}-zip \
        php${PHP_VERSION}-calendar \
        php${PHP_VERSION}-iconv \
        php${PHP_VERSION}-imap \
        php${PHP_VERSION}-soap \
        php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-exif \
        php${PHP_VERSION}-xsl \
        php${PHP_VERSION}-ldap \
        php${PHP_VERSION}-bcmath \
        php-memcached \
        php-pear \
        php-redis \
        php-xdebug \
        rsync \
        mariadb-client \

        # Stuff for SlimerJS.
        firefox-esr=${FIREFOX_VERSION} \
        xvfb \

        # Stuff for chromy. Backstop needs version 62 for some reason.
        google-chrome-${CHROME_STABILITY}=${CHROME_VERSION} \
        && \

    ln -sf /usr/bin/php${PHP_VERSION} /usr/bin/php && \
    ln -sf /usr/sbin/php-fpm${PHP_VERSION} /usr/bin/php-fpm && \

    mkdir -p /etc/php/${PHP_VERSION}/fpm/conf.d && \

    # Install imagick
    sed -ie 's/-n//g' /usr/bin/pecl && \
    yes | pecl install imagick && \
    echo 'extension=imagick.so' > /etc/php/${PHP_VERSION}/fpm/conf.d/imagick.ini && \

    # Install uploadprogess
    cd /tmp/ && wget https://github.com/Jan-E/uploadprogress/archive/master.zip && \
    unzip master.zip && \
    cd uploadprogress-master/ && \
    phpize && ./configure --with-php-config=/usr/bin/php-config && \
    make && make install && \
    echo 'extension=uploadprogress.so' > /etc/php/${PHP_VERSION}/fpm/conf.d/20_uploadprogress.ini && \
    cd .. && rm -rf ./master.zip ./uploadprogress-master && \

    # Disable Xdebug
    #rm /etc/php${PHP_VERSION}/fpm/conf.d/xdebug.ini && \

    # Install composer
    curl -sS https://getcomposer.org/installer | php${PHP_VERSION} -- --install-dir=/usr/local/bin --filename=composer && \

    # Install PHPUnit
    curl -sSL https://phar.phpunit.de/phpunit.phar -o phpunit.phar && \
        chmod +x phpunit.phar && \
        mv phpunit.phar /usr/local/bin/phpunit && \

#    # Install drush
#    php -r "readfile('https://s3.amazonaws.com/files.drush.org/drush.phar');" > /usr/local/bin/drush && \
#    chmod +x /usr/local/bin/drush && \

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
        /etc/php/${PHP_VERSION}/fpm/php.ini && \

    echo "error_log = \"/proc/self/fd/2\"" | tee -a /etc/php/${PHP_VERSION}/fpm/php.ini

# @todo: Maybe explode this into 2 dockerfiles? One base and one QAS?
# Add default drush aliases | 186MB
RUN mkdir -p /etc/drush/site-aliases && \
    mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www && \
    # Install PhantomJS through zip. 66MB
    cd /usr/local/share && \
    wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64.tar.bz2 && \
    tar xjf phantomjs-${PHANTOMJS_VERSION}-linux-x86_64.tar.bz2 && \
    rm phantomjs-${PHANTOMJS_VERSION}-linux-x86_64.tar.bz2 && \
    ln -sf /usr/local/share/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs && \
    ln -sf /usr/local/share/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64/bin/phantomjs /usr/local/phantomjs && \
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
    cd /usr/local/share/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64 && \
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
COPY 00_opcache.ini 00_xdebug.ini /etc/php/${PHP_VERSION}/fpm/conf.d/
COPY php-fpm.conf /etc/php/${PHP_VERSION}/fpm/

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
RUN composer global require hirak/prestissimo drush/drush --optimize-autoloader && \
    rm -rf ~/.composer/.cache

USER root
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]