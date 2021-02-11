FROM centos:centos7

MAINTAINER Mikhail Lugovoy

RUN yum update -y \
&& yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y   \
&& yum -y install yum-utils \
&& yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y \
&& yum-config-manager --enable remi-php72 \
&& yum update -y \
&& yum install -y nginx \
&& yum -y install php php-fpm php-common php-gd php-ldap php-mbstring php-mysqlnd php-opcache php-pdo php-pecl-zip php-xml wget  \
&& mkdir -p /home/bitrix/www \
&& chown -R nginx:nginx /home/bitrix/www \
&& cd /home/bitrix/www \
&& wget https://www.1c-bitrix.ru/download/scripts/bitrixsetup.php \
&& chmod +x bitrixsetup.php \
&& chown nginx:nginx /var/lib/php/session \
&& echo "opcache.revalidate_freq = 0" >> /etc/php.d/10-opcache.ini \
&& mkdir /run/php-fpm \
&& chmod 777 /run/php-fpm \
&& rm -rf /etc/php.d/10-opcache.ini \
&& rm -rf /etc/php.ini \
&& rm -rf /etc/php-fpm.d/www.conf \
&& mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf_orig

# ADD Command copy the files from source on the host to destination on the container's file system
# Usage: ADD source destination
ADD ./nginx.conf /etc/nginx/nginx.conf
ADD ./bitrix.conf /etc/nginx/conf.d/
ADD ./10-opcache.ini /etc/php.d/10-opcache.ini
ADD ./php.ini /etc/php.ini
ADD ./www.conf /etc/php-fpm.d/www.conf
ADD ./start.sh /
RUN chmod +x /start.sh

EXPOSE 80

CMD ["/start.sh"]
