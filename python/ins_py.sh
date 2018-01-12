#!/bin/bash
# ins_py.sh

## todo list
# 1. can not install uwsgi through pip, must comment line 24 `sed ... readline...`

set -e


if [ -f /etc/redhat-release ]; then
  yum install -y gcc-c++ zlib-devel openssl-devel sqlite-devel readline-devel
fi

#if [ -z "$(uname -a|grep centos)" ]; then
#  sudo apt-get install -y build-essential zlib1g zlib1g-dev openssl libssl-dev sqlite3 libsqlite3-dev   libreadline6-dev libbz2-dev libxml2-dev libxslt1 libffi-dev libssl-dev
#fi


[ ! -f "Python-3.5.2.tgz" ] && wget https://www.python.org/ftp/python/3.5.2/Python-3.5.2.tgz || echo "use local package"

tar zxf Python-3.5.2.tgz
cd Python-3.5.2

sed -i 's/^#readline/readline/g' Modules/Setup.dist
sed -i 's/^#zlib/zlib/g' Modules/Setup.dist
./configure --prefix=/opt/py352 --with-ensurepip=install

make && make install
