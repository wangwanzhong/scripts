## 参考
- https://github.com/mongodb/mongo/blob/master/rpm/

## 开启授权

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