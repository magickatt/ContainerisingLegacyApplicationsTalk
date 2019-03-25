FROM php:7.2.16-apache-stretch

# Add the site configuration for Apache
COPY configuration/mybb.conf /etc/apache2/sites-available/mybb.conf
RUN a2ensite mybb.conf
RUN a2dissite 000-default

# Specify Production PHP configuration
RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php.ini

# Setup SQLite
RUN mkdir /var/db
COPY database/mybb.sdb /var/db/mybb.sdb
RUN chown www-data: /var/db -R

RUN mkdir /var/www/html/mybb

# Theme cache is not regenerated on the fly so needs to be copied in manually
COPY cache/themes /var/www/html/mybb/cache/themes

COPY application /var/www/html/mybb

# Lock MyBB installation directory (will not load otherwise)
RUN echo 1 > /var/www/html/mybb/install/lock

# Configure Apache web root
RUN mv /var/www/html/mybb/htaccess.txt /var/www/html/mybb/.htaccess

# Configure MyBB
COPY configuration/config.php /var/www/html/mybb/inc
COPY configuration/settings.php /var/www/html/mybb/inc

RUN chown www-data: /var/www/html/mybb -R

EXPOSE 80
