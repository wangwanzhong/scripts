#!/bin/bash
#
#
# wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/python/ins_py.sh -O -| /bin/bash -s 3.8.0
#
# 如果不输入版本会默认使用 DefaultVersion 指定版本
# wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/python/ins_py.sh -O -| /bin/bash
# ./ins_py.sh ${version}
#
# sqlite3 --version
#

set -e

DefaultVersion=3.9.6
openssl_version=${2-1.1.1w}

Version=${1:-$DefaultVersion}


if [ -f "/etc/lsb-release" ]; then
  sudo apt-get install -y build-essential zlib1g zlib1g-dev openssl libssl-dev sqlite3 libsqlite3-dev libreadline6-dev libbz2-dev libxml2-dev libxslt1 libffi-dev libssl-dev
else
  # ModuleNotFoundError: No module named '_bz2'
  # yum install bzip2-devel
  # libyaml-devel  libyaml libxml2 libxslt-devel libxml2-devel{@class=h5 text-secondary mb-4}
  yum install -y gcc-c++ make zlib-devel openssl-devel sqlite-devel readline-devel libffi-devel bzip2-devel wget
fi

echo "install openssl-${openssl_version}"

if [ ! -f "openssl-${openssl_version}.tar.gz" ]; then
    wget --no-check-certificate https://www.openssl.org/source/openssl-${openssl_version}.tar.gz
fi

[ -d "openssl-${openssl_version}" ] && rm -rf openssl-${openssl_version}
tar zxf openssl-${openssl_version}.tar.gz && cd openssl-${openssl_version}
./config --prefix=/opt/openssl-${openssl_version} && make && make install
ln -s /opt/openssl-${openssl_version} /opt/openssl

echo "编译 Python 时指定 --with-openssl=/opt/openssl-${openssl_version}"

cd ..

if [ ! -f "Python-${Version}.tgz" ]; then
    wget https://www.python.org/ftp/python/${Version}/Python-${Version}.tgz
else
    echo "use local package"
fi

tar zxf Python-${Version}.tgz
cd Python-${Version}

#sed -i 's/^#readline/readline/g' Modules/Setup.dist
#sed -i 's/^#zlib/zlib/g' Modules/Setup.dist
sed -i 's/^#readline/readline/g' Modules/Setup
sed -i 's/^#zlib/zlib/g' Modules/Setup
#./configure --prefix=/opt/py_${Version} --with-ensurepip=install

# with you own openssl
#./configure --prefix=/opt/py_${Version} --with-ensurepip=install --with-openssl=/opt/openssl

# optimizations will increase build time extremely 
#./configure --prefix=/opt/py_${Version} --with-ensurepip=install --enable-optimizations

make && make install

#echo "export PATH=/opt/py_${Version}/bin:"'$PATH' >> /etc/profile
#source /etc/profile

# 国内可以修改源
#pip3 config set global.index-url https://mirrors.aliyun.com/pypi/simple/
