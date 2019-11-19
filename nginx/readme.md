### install
wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/nginx/ins_nginx.sh -O -| /bin/bash -s 1.16.1

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

#nginx -t && nginx
systemctl cat nginxd
systemctl start nginxd
systemctl enable nginxd
```


### 优化
```
echo '# eb
net.ipv4.tcp_max_tw_buckets = 16000
net.ipv4.ip_local_port_range = 1024    65000
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.core.somaxconn = 262144
net.core.netdev_max_backlog = 262144
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 30' >> /etc/sysctl.conf

sysctl -p

echo '* soft nofile 85534
* hard nofile 85534
* soft nproc 65535
* hard nproc 65535
* soft core 20480' >> /etc/security/limits.conf
```