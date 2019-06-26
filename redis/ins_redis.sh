#!/bin/bash
# Usage: ./ins-redis.sh 3.2.8
# wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/redis/ins_redis.sh -O -| /bin/bash

set -e

DEFAULT_VERSION="3.2.8"

[ -z "$1" ] && VERSION=${DEFAULT_VERSION} || VERSION=$1

echo "Install version ${VERSION}"

yum -y install gcc-c++ make

[ ! -f "redis-${VERSION}.tar.gz" ] && wget http://download.redis.io/releases/redis-${VERSION}.tar.gz || echo "use local package"

tar zxf redis-${VERSION}.tar.gz
cd redis-${VERSION}
#(if can not pass: cd deps &&  make hiredis  jemalloc  linenoise  lua)
make && make PREFIX=/opt/redis-${VERSION} install

rm -rf /opt/redis
ln -s /opt/redis-${VERSION} /opt/redis
mkdir -p /opt/redis/etc
cp redis.conf /opt/redis/etc/
ln -sf /opt/redis/etc/redis.conf /etc/redis.conf
ln -sf /opt/redis/bin/* /usr/local/bin/

#echo 'vm.overcommit_memory = 1' >> /etc/sysctl.conf
#sysctl vm.overcommit_memory=1

#redis-cli ping

# 关闭 rdb
# config get save
# config set save ""

# 关闭 aof
# config get appendfsync
# config set appendfsync no 