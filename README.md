## 说明

自动安装脚步，包括

 - Nginx
 - PHP
 - Redis
 - Python

## Nginx

#### 安装

> 默认版本 1.9.9 或者指定版本

    # wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/nginx/ins_nginx.sh -O -| /bin/bash
	# wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/nginx/ins_nginx.sh -O -| /bin/bash -s 1.9.9
	$ wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/nginx/ins_nginx.sh -O -| sudo /bin/bash -s 1.10.3

#### 修改 Nginx 配置
	# /bin/cp -a certs vhosts mime.types nginx.conf /opt/nginx/conf/
	# vim /opt/nginx/conf/nginx.conf

#### 根据配置初始化操作
	mkdir -p /dbdata/logs
	mkdir -p /dbdata/web/default
	mkdir -p /dbdata/web/vhosts
	echo -e "nginx work" > /dbdata/web/default/index.html
	chown -R www /dbdata/web/

#### 检查配置

    nginx -t

#### 启动 Nginx（任选一种方式）

 1. 直接启动

	    nginx
	    echo '/opt/nginx/sbin/nginx' >> /etc/rc.d/rc.local
    
 2. 使用 Systemctl 启动
 
	    cp nginxd.service /usr/lib/systemd/system
		systemctl start nginxd  
		systemctl enable nginxd

## PHP

#### 安装

> 默认版本 5.6.18 或者指定版本

	# wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/php/ins_php.sh -O -| /bin/bash
	# wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/php/ins_php.sh -O -| /bin/bash -s 5.6.32
	$ wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/php/ins_php.sh -O -| sudo /bin/bash -s 5.6.32

#### 修改 PHP 配置
	/bin/cp php.ini php-fpm.conf /opt/php/etc/
	vim /etc/php/php.ini
	php-fpm -t

#### 启动 PHP-FPM（任选一种方式）

 1. 直接启动

	    php-fpm
	    echo '/opt/php/sbin/php-fpm' >> /etc/rc.d/rc.local
 
 2. 使用 Systemctl 启动
	
	    cp phpd.service /usr/lib/systemd/system
		systemctl start phpd  
		systemctl enable phpd


#### 安装扩展（可选）

Pecl 安装较简单，优先选择

    # 安装最新版
    pecl install mongo
    # 安装指定版本
    pecl install mongodb-1.3.2
    
源码安装

> 源码来源

 > 1. 相关扩展的第三方官网
 > 2. PHP 源码中，例如 pdo_mysql 扩展位于源码中 ext/pdo_mysql/ 目录
 > 3. [Pecl 官网](https://pecl.php.net/)

下载源码后解压进入根目录执行以下命令：

    /opt/php/bin/phpize
	./configure --with-php-config=/opt/php/bin/php-config
	make && make install

重新加载配置

    vim /etc/php/php.ini
    php-fpm -t
    kill -USR2 `cat /var/run/php-fpm.pid`

#### 验证结果

    echo -e "<?php \n\tphpinfo();\n?>" > /dbdata/web/default/phpinfo.php 


## Redis

#### 安装

> 默认版本： 3.2.8

    wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/redis/ins_redis.sh -O -| /bin/bash
    wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/redis/ins_redis.sh -O -| /bin/bash -s 3.2.8
    wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/redis/ins_redis.sh -O -| sudo /bin/bash -s 3.2.8

#### 配置并启动

    vim /etc/redis.conf 
    
    # 方式一：直接启动
    redis-server /etc/redis.conf
    echo '/usr/local/bin/redis-server /etc/redis.conf' >> /etc/rc.d/rc.local
    
    # 方式二：使用 systemctl 启动
    cp redisd.service /usr/lib/systemd/system
    systemctl start redisd 
    systemctl enable redisd
    

## Python

#### 安装

> 版本： 3.5.2

    wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/python/ins_py.sh -O -| /bin/bash
    
    # 安装 pip （可选）
    wget https://bootstrap.pypa.io/get-pip.py -O - |python