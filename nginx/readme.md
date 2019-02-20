
### http2

- requirment

> openssl > 1.0.2 `--with-http_v2_module`
```
openssl version -a

wget https://www.openssl.org/source/openssl-1.1.0e.tar.gz

tar zxf openssl-1.1.0e.tar.gz 

cd openssl-1.1.0e

cd nginx-1.9.9

./configure \
    --prefix=/opt/nginx_1.9.9 \
    --user=www \
    --with-http_stub_status_module \
    --with-http_realip_module \
    --with-http_gzip_static_module \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-openssl=../openssl-1.1.0e

make && make install

/opt/nginx_1.9.9/sbin/nginx -V

listen 443 ssl http2;

nginx -t && nginx
```