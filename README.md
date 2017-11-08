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



## nginx

```
default version: 1.9.9 or specific version 
# wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/nginx/ins_nginx.sh -O -| /bin/bash
# wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/nginx/ins_nginx.sh -O -| /bin/bash -s 1.9.9
# wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/nginx/ins_nginx.sh -O -| sudo /bin/bash -s 1.10.3
# mkdir -p /dbdata/logs
# mkdir -p /dbdata/web/default
# mkdir -p /dbdata/web/vhosts
# echo -e "<?php \n\tphpinfo();\n?>" > /dbdata/web/default/phpinfo.php 
# chown -R www /dbdata/web/
# vim /opt/nginx/conf/nginx.conf
# nginx -t
# nginx 
```


## php

```
default version: 5.6.18 or specific version 
# wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/php/ins_php.sh -O -| /bin/bash
# wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/php/ins_php.sh -O -| /bin/bash -s 5.6.32
(run script ins_extension.sh to install extension)
(install extension pdo_mysql in php-{version}/ext/pdo_mysql/)
# php-fpm -t
# php-fpm
```

## python

- default version 3.5.2

```
# wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/python/ins_py.sh -O -| /bin/bash
```