#!/bin/bash
# version: nginx-1.9.9

set -e

yum -y install pcre-devel openssl-devel


wget http://nginx.org/download/nginx-1.9.9.tar.gz
tar zxf nginx-1.9.9.tar.gz
cd nginx-1.9.9
useradd -M www
./configure --prefix=/opt/nginx --user=www --with-http_stub_status_module --with-http_realip_module --with-http_gzip_static_module --with-http_ssl_module
make && make install


ln -s /opt/nginx/sbin/nginx /usr/local/bin/