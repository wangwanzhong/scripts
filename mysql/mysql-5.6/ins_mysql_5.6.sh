#!/bin/bash

set -e

SrcFile=$1
InstallDir='/opt'
DataDir='/data/db/mysqldata'

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

rm -rf /opt/mysql
tar zxf ${SrcFile} -C ${InstallDir}
ln -s ${InstallDir}/`basename ${SrcFile%.tar.gz}`/ ${InstallDir}/mysql
mkdir -p ${DataDir}
cd ${InstallDir}/mysql
chown -R root.mysql .
chown -R mysql ${DataDir}
cat support-files/my-default.cnf|egrep -v "^$|^#" > my.cnf
ln -sf ${InstallDir}/`basename ${SrcFile%.tar.gz}`/my.cnf /etc/my.cnf
./scripts/mysql_install_db --datadir=${DataDir} --user=mysql
/bin/cp support-files/mysql.server /etc/init.d/mysqld
chmod u+x /etc/init.d/mysqld

ln -sf /opt/mysql/bin/* /usr/local/bin/
ln -sf /opt/mysql/bin/* /usr/bin/
