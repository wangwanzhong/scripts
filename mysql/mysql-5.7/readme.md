# 登录 MySQL 5.7下载地址：https://dev.mysql.com/downloads/mysql/5.7.html#downloads

# 选择二进制安装包下载
wget http://cdn.mysql.com/Downloads/MySQL-5.7/mysql-5.7.22-linux-glibc2.12-x86_64.tar.gz



# 安装
./ins_mysql.sh mysql-5.7.22-linux-glibc2.12-x86_64.tar.gz


# 连接数据库，连接成功后即可以设置 root 密码和新建数据库等操作
mysql -uroot -p
mysql> alter user 'root'@'localhost' identified by '123456';
mysql> select user,host from mysql.user;
mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH  GRANT OPTION;
mysql> flush privileges;


# 调整配置
vim /etc/my.cnf
vim /etc/init.d/mysqld

# 重启
/etc/init.d/mysqld start

# 查看启动状态
/etc/init.d/mysqld status



## 在 centos6 32 机器上使用 rpm 包安装 mysql 5.7
> rpm 安装包 https://dev.mysql.com/downloads/repo/yum/

```
echo '# Enable to use MySQL 5.7
[mysql57-community]
name=MySQL 5.7 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/6/$basearch/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql' >> /etc/yum.repos.d/mysql.repo

yum repolist enabled | grep mysql
```