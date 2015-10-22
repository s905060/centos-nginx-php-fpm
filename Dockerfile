############################################################
# Dockerfile to build CentOS,Nginx,PHP-fpm installed  Container
# Based on CentOS
############################################################

# Set the base image to CentOS
FROM centos:centos6

# File Author / Maintainer
MAINTAINER "Jash Lee" <s905060@gmail.com>

# Clean up yum repos to save spaces
RUN yum update -y >/dev/null

# Install epel repos
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

# Installing epel
RUN yum -y install epel-release

# Install Nginx and php-fpm and useful tool
RUN yum --enablerepo=remi install -y wget nginx php-fpm php-common php-mysql php-cli php-ldap php-mbstring \
php-gd php-pdo php-xml php-soap vim java

# Installing supervisor (watch dog)
RUN wget https://svn.apache.org/repos/asf/oodt/tools/oodtsite.publisher/trunk/distribute_setup.py
RUN python distribute_setup.py
RUN yum install -y python-setuptools
RUN easy_install pip
RUN pip install distribute --upgrade
RUN pip install supervisor
RUN touch /var/log/php5-fpm.log

# Adding the configuration file of the nginx
ADD nginx.conf /etc/nginx/nginx.conf
ADD default.conf /etc/nginx/conf.d/default.conf

# Adding the configuration file of the Supervisor
ADD supervisord.conf /etc/

# Adding the default file
ADD index.php /var/www/index.php

# Setup Volume
VOLUME ["/var/www/", "/etc/nginx/conf.d/"]

# Set the port to 80 && 443
EXPOSE 80
EXPOSE 443

# Executing supervisord  (-n, --nodaemon Run supervisord in the foreground.)
CMD /usr/bin/supervisord -c /etc/supervisord.conf
