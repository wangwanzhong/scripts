#!/bin/bash
# ins_py.sh

set -e

yum install -y gcc-c++

# requirement packages HTTPSHandler、zlib、pysqlite
yum install -y zlib-devel openssl-devel sqlite-devel readline-devel

[ ! -f "Python-3.5.2.tgz" ] && wget https://www.python.org/ftp/python/3.5.2/Python-3.5.2.tgz || echo "use local package"

tar zxf Python-3.5.2.tgz
cd Python-3.5.2

# commit readline readline.c -lreadline -ltermcap
sed -i 's/^#readline/readline/g' Modules/Setup.dist
./configure --prefix=/opt/py352 --with-ensurepip=install

make && make install
