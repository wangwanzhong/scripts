## 参考
- https://github.com/mongodb/mongo/blob/master/rpm/
- 查看版本：https://www.mongodb.com/download-center/community/releases

# 一、准备工作

``` bash
# 查看版本
# https://www.mongodb.com/download-center/community/releases
```

## 二、安装

## 方法一：二进制安装

``` bash
# 下载安装包
wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-4.0.6.tgz

# 执行安装脚本，默认版本 4.0.6 或者通过 -s 指定其他版本
# wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/mongodb/ins_mongo.sh -O -| /bin/bash -s rhel80-4.4.5
```

## 方法二：包管理器安装

> 参考地址：https://docs.mongodb.com/manual/tutorial/install-mongodb-on-red-hat/

``` bash
echo '[mongodb-org-4.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc' > /etc/yum.repos.d/mongodb-org-4.4.repo

# 安装最新版
sudo yum install -y mongodb-org

# 或者指定版本安装
sudo yum install -y mongodb-org-4.4 mongodb-org-server-4.4 mongodb-org-shell-4.4 mongodb-org-mongos-4.4 mongodb-org-tools-4.4

# 默认配置
data_dir='/var/lib/mongo'
log_dir='/var/log/mongodb'
# 自定义配置
data_dir='/data/mongodb/'
log_dir='/data/logs/mongodb'
sudo mkdir -p ${data_dir}
sudo mkdir -p ${log_dir}
sudo chown -R mongod:mongod ${data_dir} ${log_dir}

# 如果修改默认配置
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

vim /usr/lib/systemd/system/mongod.service
添加两行
ExecStartPre=/bin/sh -c 'echo never | tee /sys/kernel/mm/transparent_hugepage/enabled > /dev/null'
ExecStartPre=/bin/sh -c 'echo never | tee /sys/kernel/mm/transparent_hugepage/defrag > /dev/null'

# 启动
systemctl daemon-reload
systemctl start mongodb
systemctl status mongodb
systemctl enable mongodb

# 日志切割
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

```

## 三、 修改配置

### 开启授权（可选）

- 添加账号

- 修改配置

``` bash
security:
    authorization: enabled
```

- 重启服务

``` bash
systemctl restart mongodb
```

## ARM64 位安装方法

``` bash
wget https://repo.mongodb.org/yum/amazon/2/mongodb-org/4.4/aarch64/RPMS/mongodb-org-server-4.4.6-1.amzn2.aarch64.rpm
yum install mongodb-org-server-4.4.6-1.amzn2.aarch64.rpm


wget https://fastdl.mongodb.org/tools/db/mongodb-database-tools-amazon2-arm64-100.3.1.rpm
yum install mongodb-database-tools-amazon2-arm64-100.3.1.rpm
```