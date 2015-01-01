FROM phusion/baseimage:0.9.9

ENV HOME /root
ENV    DEBIAN_FRONTEND noninteractive

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

CMD ["/sbin/my_init"]
ADD karmic.list /etc/apt/sources.list.d/karmic.list
ADD php /etc/apt/preferences.d/php

RUN apt-get update
RUN apt-get -y install php5 libapache2-mod-php5 php5-xsl php5-gd php-pear php5-mysql php5-curl php5-memcache
RUN apt-get -y install apache2 mysql-server php5 libapache2-mod-php5 php5-xsl php5-gd php-pear libapache2-mod-auth-mysql php5-mysql php5-curl php5-memcache
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf
ADD apache2.sh /etc/service/apache2/run
RUN chmod +x /etc/service/apache2/run

EXPOSE 80

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
