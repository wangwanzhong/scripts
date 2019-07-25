## 参考
- https://github.com/mongodb/mongo/blob/master/rpm/


## 一、 安装
```
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
