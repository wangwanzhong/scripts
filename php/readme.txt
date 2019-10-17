- install
```
 wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/php/ins_php.sh -O -| /bin/bash -s 7.3.10
mkdir -p /data/web/ /data/logs
```

- composer
```
curl -sS https://getcomposer.org/installer | /data/soft/php/bin/php -- --install-dir=/usr/bin
ln -s /usr/bin/composer.phar /usr/bin/composer
composer -V
```

- zlib
```
zlib.output_compression = On
zlib.output_compression_level
```