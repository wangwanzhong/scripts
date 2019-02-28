tar zxf mongodb-linux-x86_64-4.0.3.tgz -C /opt/
ln -s /opt/mongodb-linux-x86_64-4.0.3/ /opt/mongodb
ln -s /opt/mongodb/bin/* /usr/bin/

mkdir -p {/data/logs/mongodb/,/data/db/mongodb/,/etc/mongod}
useradd mongodb
chown -R mongodb /data/db/mongodb/ /data/logs/mongodb/

echo '[Unit]
Description=MongoDB Database Service
Wants=network.target
After=network.target

[Service]
Type=forking
PIDFile=/data/db/mongodb/mongod.pid
ExecStart=/usr/bin/mongod --config /etc/mongod/mongod.yaml
ExecReload=/bin/kill -HUP $MAINPID
Restart=always
User=mongodb
Group=mongodb
StandardOutput=syslog
StandardError=syslog

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/mongodb.service


echo 'systemLog:
  destination: file
  path: /data/logs/mongodb/mongod.log
  logAppend: true
storage:
  journal:
    enabled: true
  dbPath: /data/db/mongodb/
  directoryPerDB: true
  wiredTiger:
    engineConfig:
      directoryForIndexes: true
processManagement:
  fork: true
  pidFilePath: /data/db/mongodb/mongod.pid
net:
  bindIp: 127.0.0.1
  port: 27017
security:
  authorization: enabled' > /etc/mongod/mongod.yaml



systemctl start mongodb
systemctl status mongodb
systemctl enable mongodb