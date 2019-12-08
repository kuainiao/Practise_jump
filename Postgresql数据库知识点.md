Windows安装方法：

CentOS安装方法：
#########################################################################################################################################################################################
#!/usr/bin/env bash
yum -y install gcc gcc-c++ ncurses ncurses-devel cmake systemtap-sdt-devel.x86_64 perl-ExtUtils-Embed readline readline-devel pam pam-devel libxslt libxslt-devel tcl tcl-devel python-devel

wget https://ftp.postgresql.org/pub/source/v11.2/postgresql-11.2.tar.gz
mkdir -p /data/soft/
tar -zxvf postgresql-11.2.tar.gz -C /data/soft/
mv /data/soft/postgresql-11.2/ /data/soft/postgresql/
cd /data/soft/postgresql
./configure --prefix=/usr/local/pgsql --without-readline
make && make install

rm -rf /home/postgres
adduser postgres
chown -R postgres:root /usr/local/pgsql/
mkdir -p /usr/local/pgsql/data
mkdir -p /home/postgres
chown -R postgres:root /usr/local/pgsql/data

su postgres
echo "export PATH=/usr/local/pgsql/bin:$PATH" >> ~/.bash_profile
echo "export PGDATA=/usr/local/pgsql/data"    >> ~/.bash_profile
echo "export LD_LIBRARY_PATH=/usr/lib:/usr/local/pgsql/lib:/usr/local/lib" >> ~/.bash_profile
source ~/.bash_profile
/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data/
/usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data/ > logfile 2>&1 &
/usr/local/pgsql/bin/psql postgres postgres << EOF
ALTER USER postgres WITH PASSWORD '12345678'
\q
EOF

su -
chmod +u+x /data/soft/postgresql/contrib/start-scripts/linux
cp /data/soft/postgresql/contrib/start-scripts/linux /etc/init.d/postgresql
/etc/init.d/postgresql start
service postgresql start
####################################################################################################################################################

Windows 启动方法（start、restart、stop）：net start "postgresql-x64-10"
CentOS7 启动方法（start、restart、stop）：service postgresql-9.5 start

psql -p 5432 -U postgres -d postgres

学习教程
https://www.yiibai.com/postgresql/postgresql-create-database.html

列出系统：show all;


1，查看数据库：\l
2，创建数据库：create database testdb;
3，删除数据库：drop database testdb;
4，创建数据表：CREATE TABLE public.student2(id integer NOT NULL,name character(100),
subjects character(1),CONSTRAINT student2_pkey PRIMARY KEY (id))WITH (OIDS=FALSE);
ALTER TABLE public.student2 OWNER TO postgres;
COMMENT ON TABLE public.student2  IS '这是';
5，