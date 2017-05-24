#!/bin/bash
# version: php-5.6.18

set -e

function ins_ext(){

    tar zxf ${1}.tgz
    cd ${1}
    /usr/local/bin/phpize
    ./configure --with-php-config=/usr/local/bin/php-config
    make && make install
    cd ..
}


ins_ext mongo-1.6.12
ins_ext redis-3.1.1
ins_ext yaf-2.3.5
