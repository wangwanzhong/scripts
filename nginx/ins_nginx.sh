#!/bin/bash
# version: nginx-${version}

set -e

if [ -z "$1" ];then
    version="1.14.0"
else
    version=$1
fi


# requirement

/usr/bin/id www || useradd -M www

yum -y install gcc-c++ make pcre-devel openssl-devel
[ -f "nginx-${version}.tar.gz" ] || wget http://nginx.org/download/nginx-${version}.tar.gz

# install
tar zxf nginx-${version}.tar.gz
cd nginx-${version}
./configure \
    --prefix=/opt/nginx \
    --user=www \
    --with-http_stub_status_module \
    --with-http_realip_module \
    --with-http_gzip_static_module \
    --with-http_ssl_module \
    --with-http_v2_module


make && make install

# config
ln -s /opt/nginx/sbin/nginx /usr/local/bin/