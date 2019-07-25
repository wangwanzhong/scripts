## 参考
- https://github.com/mongodb/mongo/blob/master/rpm/


## 一、 安装
```
# 下载安装包
wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-4.0.6.tgz

# 执行安装脚本，默认版本 4.0.6 或者通过 -s 指定其他版本
# wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/mongodb/ins_mongo.sh -O -| /bin/bash -s 4.0.6
```


## 二、 开启授权（可选）

- 添加账号

- 修改配置
```
security:
    authorization: enabled
```

- 重启服务
```
systemctl restart mongodb
```
