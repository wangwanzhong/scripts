# PHP

- install
```
wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/php/ins_php.sh -O -| /bin/bash -s 7.3.10

sed -i "s/date.timezone =.*/date.timezone = UTC/g" /etc/php/php.ini
cp php-fpm.conf /etc/php/
cp phpd.service /usr/lib/systemd/system/phpd.service

mkdir -p /data/logs

systemctl start phpd
systemctl enable phpd
systemctl status phpd
```

- 扩展
```
pecl install yaf-3.0.8
pecl install mongodb-1.6.0
pecl install redis-5.0.2

echo '# custom extensions
[yaf]
extension=yaf.so

[mongodb]
extension=mongodb.so

[redis]
extension=redis.so' >> /etc/php/php.ini
```

- composer
```
curl -sS https://getcomposer.org/installer | /opt/php/bin/php -- --install-dir=/usr/bin
ln -s /usr/bin/composer.phar /usr/bin/composer
composer -V
```

- zlib
```
zlib.output_compression = On
zlib.output_compression_level = 6
```

- 日志切割
```
mkdir -p /root/cron && cp cut_php_log.sh /root/cron/
chmod u+x /root/cron/cut_php_log.sh
echo '59 23 * * * /root/cron/cut_php_log.sh' >> /var/spool/cron/root
```