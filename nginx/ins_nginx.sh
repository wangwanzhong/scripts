#!/bin/bash
# version: nginx-1.9.9

set -e

# requirement

/usr/bin/id www || useradd -M www

yum -y install gcc-c++ make pcre-devel openssl-devel
[ -f "nginx-1.9.9.tar.gz" ] || wget http://nginx.org/download/nginx-1.9.9.tar.gz

# install
tar zxf nginx-1.9.9.tar.gz
cd nginx-1.9.9
./configure --prefix=/opt/nginx --user=www --with-http_stub_status_module --with-http_realip_module --with-http_gzip_static_module --with-http_ssl_module
make && make install

# config
ln -s /opt/nginx/sbin/nginx /usr/local/bin/