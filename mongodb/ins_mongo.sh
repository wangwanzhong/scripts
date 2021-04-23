#!/bin/bash

# check mongodb version
# wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/mongodb/ins_mongo.sh -O -| /bin/bash -s rhel80-4.4.5

set -e

default_version='rhel80-4.4.5'
data_dir='/data/mongodb/'
log_dir='/data/logs/mongodb'

version=${1:-$default_version}
tar_pkg="mongodb-linux-x86_64-${version}.tgz"
[ ! -f "${tar_pkg}" ] && echo "no install package ${tar_pkg}, downloading..." && wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-${version}.tgz


tar zxf ${tar_pkg} -C /opt/
ln -s /opt/${tar_pkg%.tgz}/ /opt/mongodb
ln -s /opt/mongodb/bin/* /usr/bin/

/usr/bin/id mongod || useradd -M mongod

mkdir -p ${data_dir}
mkdir -p ${log_dir}

chown -R mongod:mongod ${data_dir} ${log_dir}

echo "[Unit]
Description=MongoDB Database Server
Documentation=https://docs.mongodb.org/manual
After=network-online.target
Wants=network-online.target

[Service]
User=mongod
Group=mongod
Environment="OPTIONS=-f /etc/mongod.conf"
EnvironmentFile=-/etc/sysconfig/mongod
ExecStart=/usr/bin/mongod $OPTIONS
ExecStartPre=/usr/bin/mkdir -p /var/run/mongodb
ExecStartPre=/usr/bin/chown mongod:mongod /var/run/mongodb
ExecStartPre=/usr/bin/chmod 0755 /var/run/mongodb
PermissionsStartOnly=true
PIDFile=/var/run/mongodb/mongod.pid
Type=forking
# file size
LimitFSIZE=infinity
# cpu time
LimitCPU=infinity
# virtual memory size
LimitAS=infinity
# open files
LimitNOFILE=64000
# processes/threads
LimitNPROC=64000
# locked memory
LimitMEMLOCK=infinity
# total threads (user+kernel)
TasksMax=infinity
TasksAccounting=false
# Recommended limits for mongod as specified in
# https://docs.mongodb.com/manual/reference/ulimit/#recommended-ulimit-settings

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/mongodb.service


echo "systemLog:
  destination: file
  path: ${log_dir}/mongod.log
  logAppend: true
storage:
  journal:
    enabled: true
  dbPath: ${data_dir}
  directoryPerDB: true
  wiredTiger:
    engineConfig:
      directoryForIndexes: true
processManagement:
  fork: true
  pidFilePath: /var/run/mongodb/mongod.pid
net:
  bindIp: 0.0.0.0
  port: 27017
  maxIncomingConnections: 3000
security:
  authorization: disabled" > /etc/mongod.conf


systemctl daemon-reload
systemctl start mongodb
systemctl status mongodb
systemctl enable mongodb

echo 'db.serverStatus().connections' | mongo

mkdir -p /root/cron
echo '#!/bin/bash' > /root/cron/cut_mongo_log.sh

echo "

LOGFILE=${log_dir}/mongod.log

killall -SIGUSR1 mongod

DATE=\$(date -d '7 days ago' +'%Y-%m-%d')

rm -f \${LOGFILE}.\${DATE}T*-*-*" >> /root/cron/cut_mongo_log.sh

chmod u+x /root/cron/cut_mongo_log.sh
echo '59 23 * * * /root/cron/cut_mongo_log.sh' >> /var/spool/cron/root

exit 0

echo 'need download mongo tools... from https://www.mongodb.com/try/download/community'