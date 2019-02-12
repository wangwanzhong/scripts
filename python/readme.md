### install

```
# wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/python/ins_py.sh -O -| /bin/bash
```


### 注意

> 如果 Openssl 版本过低可能报错（pip is configured with locations that require TLS/SSL, however the ssl module in Python is not avail）
> 
> 解决办法：更新 openssl
> 
> 下载地址：https://www.openssl.org/source/
> 
> wget https://www.openssl.org/source/openssl-1.0.2q.tar.gz
> tar zxf openssl-1.0.2q.tar.gz
> cd openssl-1.0.2q
> ./config --prefix=/usr/local/openssl
> make
> make install
> 
> 编译 Python 时指定 --with-openssl=/usr/local/openssl
> ./configure --with-openssl=/usr/local/openssl