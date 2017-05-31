# scripts

## redis

- default version 3.2.8

```
# wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/redis/ins_redis.sh -O -| /bin/bash
# vim /etc/redis.conf 
# redis-server /etc/redis.conf
```

- install specific version

```# wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/redis/ins_redis.sh -O -| /bin/bash -s 3.2.8```


## php

```
# wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/php/ins_php.sh -O -| /bin/bash
(run script ins_extension.sh to install extension)
(install extension pdo_mysql in php-5.6.18/ext/pdo_mysql/)
# php-fpm -t
# php-fpm
```

## nginx

```
# wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/nginx/ins_nginx.sh -O -| /bin/bash
# mkdir -p /dbdata/logs
# mkdir -p /dbdata/web/default
# mkdir -p /dbdata/web/vhosts
# echo -e "<?php \n\tphpinfo();\n?>" > /dbdata/web/default/phpinfo.php 
# chown -R www /dbdata/web/
# vim /opt/nginx/conf/nginx.conf
# nginx -t
# nginx 
```

## python

- default version 3.5.2

```
# wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/python/ins_py.sh -O -| /bin/bash
```