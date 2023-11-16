### install

```
# wget https://raw.githubusercontent.com/wangwanzhong/scripts/master/python/ins_py.sh -O -| /bin/bash
```


### 注意

```
如果 Openssl 版本过低可能报错（pip is configured with locations that require TLS/SSL, however the ssl module in Python is not avail）

解决办法：更新 openssl

下载地址：https://www.openssl.org/source/

| Python | openssl |
| --- | --- |
| 3.10.12 | 1.1.1w |

openssl_version=1.1.1w
wget https://www.openssl.org/source/openssl-${openssl_version}.tar.gz
tar zxf openssl-${openssl_version}.tar.gz && cd openssl-${openssl_version}
./config --prefix=/opt/openssl-${openssl_version} && make && make install
ln -s /opt/openssl-${openssl_version} /opt/openssl
编译 Python 时指定 --with-openssl=/opt/openssl-${openssl_version}
```
