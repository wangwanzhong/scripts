#!/bin/bash

set -e

SrcFile=$1
InstallDir='/opt'
DataDir='/data/db/mysqldata'
LogDir='/data/log/mysql'

if [ ! -f "${SrcFile}" ];then
    echo "no src file ${SrcFile}"
    exit 1
fi

if ! id mysql;then
   echo "create count mysql"
   useradd mysql
else
   echo "has count mysql"
fi

if ! rpm -qi libaio-devel;then
   echo "no libaio-devel install it"
   yum install libaio-devel -y
fi

if ! rpm -qi perl-Data-Dumper;then
   echo "no perl-Data-Dumper install it"
   yum install perl-Data-Dumper -y
fi

if [ -d "/opt/mysql" ]; then
    mv /opt/mysql /opt/mysql_$(date +%Y%m%d_%s)
fi

if [ -d "${DataDir}" ]; then
    mv ${DataDir} ${DataDir}_$(date +%Y%m%d_%s)
fi

if [ ! -d "${LogDir}" ]; then
    mkdir -p ${LogDir}
    chown -R mysql ${LogDir}
fi

tar zxf ${SrcFile} -C ${InstallDir}
ln -s ${InstallDir}/`basename ${SrcFile%.tar.gz}`/ ${InstallDir}/mysql

mkdir -p ${DataDir}
cd ${InstallDir}/mysql
chown -R root.mysql .
chown -R mysql ${DataDir}

echo "[client]
default-character-set = utf8mb4

[mysqld]
#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M
#
# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M

basedir=${InstallDir}/mysql
datadir=${DataDir}
socket=/tmp/mysql.sock
log-error=${LogDir}/mysqld.log
pid-file=${DataDir}/mysqld.pid

character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

lower_case_table_names=1
skip_name_resolve = 1

# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0

max_connections=200
default-storage-engine=INNODB
#ssl=false" > /etc/my.cnf

./bin/mysqld --initialize --user=mysql --datadir=/data/db/mysqldata --basedir=/opt/mysql/
/bin/cp support-files/mysql.server /etc/init.d/mysqld
sed -i "s;^datadir=;datadir=${DataDir};g" /etc/init.d/mysqld
sed -i "s;^basedir=;basedir=${InstallDir}/mysql;g" /etc/init.d/mysqld
chmod u+x /etc/init.d/mysqld

ln -sf /opt/mysql/bin/* /usr/local/bin/
ln -sf /opt/mysql/bin/* /usr/bin/


# 启动
/etc/init.d/mysqld start

# 开机启动
chkconfig mysqld on

# 验证启动状态
/etc/init.d/mysqld status

# 找到临时生成的初始密码
grep  'A temporary password' ${LogDir}/mysqld.log
