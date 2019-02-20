echo '[Unit]
Description=MongoDB Database Service
Wants=network.target
After=network.target

[Service]
Type=forking
PIDFile=/opt/mongodb/mongod.pid
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
  pidFilePath: /opt/mongodb/mongod.pid
net:
  bindIp: 127.0.0.1
  port: 27017
security:
  authorization: enabled' > /opt/mongodb/etc/mongod.yaml



systemctl restart mongodb