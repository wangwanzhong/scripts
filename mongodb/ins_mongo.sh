#!/bin/bash

# refer: https://github.com/mongodb/mongo/blob/master/rpm/mongod.service

set -e

version='4.0.6'
data_dir='/data/db/mongodb/'
log_dir='/data/logs/mongodb'

mkdir -p ${data_dir}
mkdir -p ${log_dir}

tar_pkg="mongodb-linux-x86_64-${version}.tgz"

tar zxf ${tar_pkg} -C /opt/

ln -s /opt/${tar_pkg%.tgz}/ /opt/mongodb
ln -s /opt/mongodb/bin/* /usr/bin/

/usr/bin/id mongod || useradd -M mongod

echo "# https://github.com/mongodb/mongo/blob/master/rpm/mongod.service

[Unit]
Description=MongoDB Database Service
Wants=network.target
After=network.target
Documentation=https://docs.mongodb.org/manual

[Service]
User=mongod
Group=mongod

Environment=\"OPTIONS=-f /etc/mongod.yaml\"
EnvironmentFile=-/etc/sysconfig/mongod

ExecStart=/usr/bin/mongod \$OPTIONS
ExecStartPre=/usr/bin/mkdir -p /var/run/mongodb
ExecStartPre=/usr/bin/mkdir -p ${data_dir}
ExecStartPre=/usr/bin/mkdir -p ${log_dir}
ExecStartPre=/usr/bin/chown mongod:mongod /var/run/mongodb ${data_dir} ${log_dir}
ExecStartPre=/usr/bin/chmod 0755 /var/run/mongodb
ExecReload=/bin/kill -HUP \$MAINPID
Restart=always

PermissionsStartOnly=true

PIDFile=/var/run/mongodb/mongod.pid

Type=forking

#StandardOutput=syslog
#StandardError=syslog

# file size
LimitFSIZE=infinity
# cpu time
LimitCPU=infinity
# virtual memory size
LimitAS=infinity
# open files
LimitNOFILE=85534
# processes/threads
LimitNPROC=64000
# locked memory
LimitMEMLOCK=infinity
# total threads (user+kernel)
TasksMax=infinity
TasksAccounting=false
# Recommended limits for for mongod as specified in
# http://docs.mongodb.org/manual/reference/ulimit/#recommended-settings

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
  bindIp: 127.0.0.1
  port: 27017
  maxIncomingConnections: 3000
security:
  authorization: disabled" > /etc/mongod.yaml


systemctl daemon-reload
systemctl start mongodb
systemctl status mongodb
systemctl enable mongodb