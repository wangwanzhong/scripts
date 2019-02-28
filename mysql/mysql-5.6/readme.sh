# 下载二进制安装包
wget http://cdn.mysql.com/Downloads/MySQL-5.6/mysql-5.6.19-linux-glibc2.5-x86_64.tar.gz

# 安装（ins_mysql.sh 脚本内容详见文档结尾附一）
./ins_mysql.sh mysql-5.6.19-linux-glibc2.5-x86_64.tar.gz

# 修改配置文件（详见文档结尾附一）
vim /etc/my.cnf

# 修改启动脚本（详见文档结尾附一）
vim /etc/init.d/mysqld

# 启动
/etc/init.d/mysqld start

# 开机启动
chkconfig mysqld on

# 验证启动状态
/etc/init.d/mysqld status

# 连接数据库，第一次密码为空
# mysql -uroot -p
mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' IDENTIFIED BY 'password' WITH  GRANT OPTION;
mysql> flush privileges;
mysql> exit

# 修改密码
mysql> use mysql
mysql> update mysql.user set password=password("new password") where user='root';
mysql> flush privileges;
mysql> exit

# 连接成功后即可以设置 root 密码和新建数据库等操作