#!/bin/bash
# version: php-5.6.18

set -e

yum -y install epel-release

yum -y install gcc-c++ make libxml2-devel curl-devel libjpeg-devel libpng-devel freetype-devel zlib-devel pcre-devel openssl-devel libxml2 libxml2-devel openssl openssl-devel libcurl libcurl-devel libjpeg libjpeg-devel freetype freetype-devel libc-client libc-client-devel libtool.x86_64 libtool-ltdl.x86_64 libtool-ltdl-devel.x86_64 openldap-devel libjpeg.x86_64 libpng.x86_64 freetype.x86_64 libjpeg-devel.x86_64 libpng-devel.x86_64 freetype-devel.x86_64 krb5* mcrypt mhash-devel libmcrypt-devel mysql-devel
/usr/bin/id www || useradd -M www

ln -s /usr/lib64 /usr/kerberos/lib
ln -s /usr/lib64/libc-client.so /usr/lib/libc-client.so



[ ! -f "php-5.6.18.tar.gz" ] && wget http://am1.php.net/distributions/php-5.6.18.tar.gz || echo "use local package"

tar zxf php-5.6.18.tar.gz

cd php-5.6.18

./configure --prefix=/opt/php-5.6.18 --with-config-file-path=/etc/php --with-gd --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-imap --with-kerberos --with-imap-ssl --with-mhash --with-mcrypt --with-curl --with-openssl --with-gettext --with-iconv-dir --with-libxml-dir --with-fpm-user=www --with-fpm-group=www --with-mysql=mysqlnd --with-mysqli --enable-fpm --enable-inline-optimization --enable-mbstring --enable-gd-native-ttf --enable-mbregex --enable-soap --enable-opcache

make && make install
ln -s /opt/php-5.6.18/ /opt/php
cp php.ini-production /opt/php/etc/php.ini
mkdir /etc/php
ln -sf /opt/php/etc/* /etc/php/
ln -sf /opt/php/bin/* /opt/php/sbin/* /usr/local/bin/
