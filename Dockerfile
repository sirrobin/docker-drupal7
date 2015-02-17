FROM phusion/baseimage
MAINTAINER Andy Woods

# Set up environment
ENV HOME /root
ENV APACHE_SERVERADMIN admin@localhost
ENV APACHE_SERVERNAME localhost
ENV APACHE_SERVERALIAS docker.localhost
ENV APACHE_DOCUMENTROOT /var/www
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
RUN echo %sudo	ALL=NOPASSWD: ALL >> /etc/sudoers
RUN rm -f /etc/service/sshd/down
RUN /usr/sbin/enable_insecure_key

# Install packages.
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y apache2 php5-mysql libapache2-mod-php5 php5-gd php5-curl php5-cli

# Setup Composer
RUN curl -sS https://getcomposer.org/installer | php && \
	mv composer.phar /usr/local/bin/composer

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose ports.
EXPOSE 80

# Update the default apache site with the config we created.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

# Add services.
ADD apache2.sh /etc/service/apache2/run
RUN chmod +x /etc/service/apache2/run

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
