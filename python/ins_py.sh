#!/bin/bash
#
#
# wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/python/ins_py.sh -O -| /bin/bash -s 3.8.0
#
# 如果不输入版本会默认使用 DefaultVersion 指定版本
# wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/python/ins_py.sh -O -| /bin/bash
# ./ins_py.sh ${version}
#

set -e

DefaultVersion=3.8.0

Version=${1:-$DefaultVersion}


if [ -f "/etc/lsb-release" ]; then
  sudo apt-get install -y build-essential zlib1g zlib1g-dev openssl libssl-dev sqlite3 libsqlite3-dev   libreadline6-dev libbz2-dev libxml2-dev libxslt1 libffi-dev libssl-dev
else
  yum install -y gcc-c++ zlib-devel openssl-devel sqlite-devel readline-devel libffi-devel wget
fi


if [ ! -f "Python-${Version}.tgz" ]; then
    if ping -c 1 192.168.1.1; then
        wget ftp://192.168.1.253/ops/Python/Python-${Version}.tgz
    else
        wget https://www.python.org/ftp/python/${Version}/Python-${Version}.tgz
    fi
else
    echo "use local package"
fi

tar zxf Python-${Version}.tgz
cd Python-${Version}

#sed -i 's/^#readline/readline/g' Modules/Setup.dist
#sed -i 's/^#zlib/zlib/g' Modules/Setup.dist
sed -i 's/^#readline/readline/g' Modules/Setup
sed -i 's/^#zlib/zlib/g' Modules/Setup
./configure --prefix=/opt/py_${Version} --with-ensurepip=install

# with you own openssl
#./configure --prefix=/opt/py_${Version} --with-ensurepip=install --with-openssl=/usr/local/openssl

# optimizations will increase build time extremely 
#./configure --prefix=/opt/py_${Version} --with-ensurepip=install --enable-optimizations

make && make install

rm -rf Python-${Version}
