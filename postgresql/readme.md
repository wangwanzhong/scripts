# [postgresql docker](https://hub.docker.com/_/postgres)

# Installation
[PostgreSQL-12.3](http://www.linuxfromscratch.org/blfs/view/svn/server/postgresql.html)

- 创建运行账号
```
mkdir /srv/pgsql

groupadd -g 41 postgres &&
useradd -c "PostgreSQL Server" -g postgres -d /srv/pgsql/data \
        -u 41 postgres
```

- 编译源码
```
yum install -y bzip2 readline-deve zlib-devel systemd-devel

sed -i '/DEFAULT_PGSOCKET_DIR/s@/tmp@/run/postgresql@' src/include/pg_config_manual.h &&

./configure --prefix=/usr          \
            --enable-thread-safety \
            --docdir=/usr/share/doc/postgresql-12.3 \
            --with-systemd

make && make install && make install-docs

# Optional
# make -C contrib/<SUBDIR-NAME> install
```

- 初始化数据
```
# initialize postgresql server database
install -v -dm700 /srv/pgsql/data &&
install -v -dm755 /run/postgresql &&
chown -Rv postgres:postgres /srv/pgsql /run/postgresql

su - postgres -c '/usr/bin/initdb -D /srv/pgsql/data'
```

# 服务控制
- 启动
```
su - postgres -c '/usr/bin/pg_ctl -D /srv/pgsql/data -l logfile.log start'

# su - postgres -c '/usr/bin/postgres -D /srv/pgsql/data > /srv/pgsql/data/logfile 2>&1 &'
```
- 测试
```
su - postgres -c '/usr/bin/createdb test' &&
echo "create table t1 ( name varchar(20), state_province varchar(20) );" \
    | (su - postgres -c '/usr/bin/psql test ') &&
echo "insert into t1 values ('Billy', 'NewYork');" \
    | (su - postgres -c '/usr/bin/psql test ') &&
echo "insert into t1 values ('Evanidus', 'Quebec');" \
    | (su - postgres -c '/usr/bin/psql test ') &&
echo "insert into t1 values ('Jesse', 'Ontario');" \
    | (su - postgres -c '/usr/bin/psql test ') &&
echo "select * from t1;" | (su - postgres -c '/usr/bin/psql test')
```

- 关闭
```
su - postgres -c '/usr/bin/pg_ctl -D /srv/pgsql/data stop'
```

- /etc/systemd/system/postgresql.service
```
[Unit]
Description=PostgreSQL database server
Documentation=man:postgres(1)

[Service]
Type=notify
User=postgres
RuntimeDirectory=postgresql
ExecStart=/usr/bin/postgres -D /srv/pgsql/data
ExecReload=/bin/kill -HUP $MAINPID
KillMode=mixed
KillSignal=SIGINT
TimeoutSec=0

[Install]
WantedBy=multi-user.target
```

```
systemctl start postgresql
systemctl enable postgresql
```

# 配置
- $PGDATA/pg_hba.conf
```
host    all             all             127.0.0.1/32            trust

# add
host    all    all    0.0.0.0/0    md5
```

- $PGDATA/pg_ident.conf
- $PGDATA/postgresql.auto.conf
- $PGDATA/postgresql.conf
```
listen_addresses = '0.0.0.0'
```

> 修改配置后需要重启服务，`systemctl restart postgresql`


# 创建远程账号
```
# su - postgres -c 'psql '
psql (12.3)
Type "help" for help.

postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   
-----------+----------+----------+-------------+-------------+-----------------------
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(3 rows)

postgres=# \q
[root@wwzvm01 postgresql-12.3]# su - postgres -c 'psql '
psql (12.3)
Type "help" for help.

postgres=# create user user01 with password '123456';
CREATE ROLE
postgres=# create database testdb01 owner user01;
CREATE DATABASE
postgres=# grant all privileges on database testdb01 to user01;
GRANT
postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   
-----------+----------+----------+-------------+-------------+-----------------------
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 testdb01  | user01   | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =Tc/user01           +
           |          |          |             |             | user01=CTc/user01
(4 rows)

postgres=# \q
```
