#!/bin/bash
# ins_py.sh

set -e

# requirement packages HTTPSHandler、zlib、pysqlite
yum install -y zlib-devel openssl-devel sqlite-devel readline-devel
wget https://www.python.org/ftp/python/3.5.2/Python-3.5.2.tgz

tar zxf Python-3.5.2.tgz
cd Python-3.5.2
# commit readline readline.c -lreadline -ltermcap
sed -i 's/^#readline/readline/g' Modules/Setup.dist
./configure --prefix=/opt/py352 --with-ensurepip=install
make && make install
