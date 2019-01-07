#!/bin/bash
#
#
# Usage: ./ins_py.sh ${version}
# 如果不输入版本会默认使用 DefaultVersion 指定版本
#

set -e

DefaultVersion=3.7.0

Version=${1:-$DefaultVersion}


if [ -f "/etc/lsb-release" ]; then
  sudo apt-get install -y build-essential zlib1g zlib1g-dev openssl libssl-dev sqlite3 libsqlite3-dev   libreadline6-dev libbz2-dev libxml2-dev libxslt1 libffi-dev libssl-dev
else
  yum install -y gcc-c++ zlib-devel openssl-devel sqlite-devel readline-devel libffi-devel wget
fi


if [ ! -f "Python-${Version}.tgz" ]; then
    wget https://www.python.org/ftp/python/${Version}/Python-${Version}.tgz
    # wget ftp://192.168.1.253/ops/Python/Python-${Version}.tgz
else
    echo "use local package"
fi

tar zxf Python-${Version}.tgz
cd Python-${Version}

sed -i 's/^#readline/readline/g' Modules/Setup.dist
sed -i 's/^#zlib/zlib/g' Modules/Setup.dist
./configure --prefix=/opt/py_${Version} --with-ensurepip=install --enable-optimizations

make && make install
