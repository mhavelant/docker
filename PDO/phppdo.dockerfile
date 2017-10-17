FROM wodby/drupal-php:7.0-2.4.3

USER root
RUN apk add --update --no-cache php7-pdo_dblib
USER www-data
