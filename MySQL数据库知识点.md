yum -y install wget gcc gcc-c++ ncurses ncurses-devel cmake numactl.x86_64 libaio
wget http://mirrors.ustc.edu.cn/mysql-ftp/Downloads/MySQL-5.7/mysql-5.7.29-linux-glibc2.12-x86_64.tar.gz

tar -zxvf mysql-5.7.29-linux-glibc2.12-x86_64.tar.gz -C /usr/local/
mv /usr/local/mysql-5.7.29-linux-glibc2.12-x86_64/ /usr/local/mysql
cd /usr/local/mysql/
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql
cat >/etc/my.cnf <<EOF
[client]
port=3318
socket=/tmp/mysql.sock
[mysqld]
port=3318
socket=/tmp/mysql.sock
skip-external-locking
key_buffer_size = 38M
max_allowed_packet = 1M
table_open_cache = 64
sort_buffer_size = 512K
net_buffer_length = 8K
read_buffer_size = 256K
read_rnd_buffer_size = 512K
myisam_sort_buffer_size = 8M
basedir=/usr/local/mysql
datadir=/var/lib/mysql
bind-address=0.0.0.0
innodb_flush_log_at_trx_commit=1
sync_binlog=1
log-bin=/var/lib/mysql/mysql_logbin
log-error=/var/log/mariadb
slow_query_log =1
slow_query_log_file=/tmp/mysql_slow.log
server-id=1
symbolic-links=0
[mysqld_safe]
pid-file=/var/run/mariadb/mariadb.pid
EOF


useradd mysql
mkdir -p /usr/local/mysql/data
chown mysql:mysql /usr/local/mysql/data
mkdir -p /var/lib/mysql
chown mysql:mysql /var/lib/mysql
mkdir -p /var/log/mariadb
chown mysql:mysql /var/log/mariadb/
touch /var/log/mariadb/mariadb.log
mkdir -p /var/run/mariadb
chown mysql:mysql /var/run/mariadb/
touch /var/run/mariadb/mariadb.pid
mv /var/lib/mysql/ /var/lib/mysql_bak/
cat  >> /etc/profile << EOF
export PATH=\$PATH:/usr/local/mysql/bin:/usr/local/mysql/lib
EOF
source /etc/profile
mysqld --defaults-file=/etc/my.cnf --user=mysql --initialize-insecure
/etc/init.d/mysql start

firewall-cmd --zone=public --add-port=1186/tcp --permanent
firewall-cmd --reload
######################  yum 安装mysql ######################
rpm -qa | grep mariadb
#如果找到，则拷贝结果，使用下面命令删除，如删除mariadb-libs-5.5.35-3.el7.x86_64
rpm -e --nodeps mariadb-libs-5.5.60-1.el7_5.x86_64
wget -i -c http://dev.mysql.com/get/mysql57-community-release-el7-10.noarch.rpm
yum -y install mysql57-community-release-el7-10.noarch.rpm
yum -y install mysql-community-server
service mysqld restart

grep "password" /var/log/mysqld.log   
mysql -u root -p 

alter user 'root'@'localhost' identified by 'wanke123456';  
flush privileges;
alter user 'root'@'%' identified by 'wanke123456';  
flush privileges;
CREATE DATABASE `test_aomm_2020` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON test_aomm_2020.* TO 'dxops'@'%' IDENTIFIED BY 'dx2018' with grant option;
flush privileges;
##################################################################

# 1，非交互式命令创建dog用户：mysql -h127.0.0.1 -P3306 -uroot -p123456 -e "SHOW VARIABLES LIKE 'validate_password%';" 2>/dev/null
# 2，无警告非交互式命令执行：mysql -u root -p123456 -h 127.0.0.1 -P 3306 -Bse "show plugins;" 2>/dev/null
# 3，创建可外部链接用户dog：CREATE USER 'dog'@'%' IDENTIFIED BY '12345678990';
# 4，删除用户dog：DROP USER 'dog'@'%';
# 5，设置dog用户密码：SET PASSWORD FOR 'dog'@'%' = PASSWORD('1234564e6456456456');
# 6，列出已安装插件：SHOW VARIABLES;
# 7，安装密码插件：INSTALL PLUGIN validate_password SONAME 'validate_password.so';
# 8，MySQL加速连接：vi /etc/my.cnf
[mysqld]
skip-name-resolve
# 9，
# 10，python的mysql高并发方案Tormysql+Tornado
# 10，自动事务化分库分表spanner：https://cloud.google.com/forrester-dbaas/?hl=zh-cn
# 11，查询对应地区的任务数：  select count(*) from t_operation_task where task_area = '08';
# 12，查询相同数据出现的次数：select country as 国家,count(*) as 次数 from table3 group by country;
      查询时间段：select fullName,addedTime FROM t_user where addedTime between  '2017-1-1 00:00:00'  and '2018-1-1 00:00:00'; 
# 13，MySQL重置密码：vi /etc/my.cnf
# 14，创建数据库并授权： 
     CREATE DATABASE `we9` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
     GRANT ALL PRIVILEGES ON we9.* TO 'root'@'%' IDENTIFIED BY 'wanke@W123456' with grant option;
	 flush privileges;
# 15，创建用户并授权：
     CREATE USER 'sa'@'%' IDENTIFIED BY 'ioszdhyw';
     GRANT ALL PRIVILEGES ON RAP2_DELOS_APP.* TO 'sa'@'%' IDENTIFIED BY 'ioszdhyw' with grant option;
     flush privileges;
# 16，指定mysql.sock位置：/home/mysql/mariadb/bin/mysql -uioszdhyw -p -S /home/mysql/mariadb/mysql.sock
[mysqld]
skip-grant-tables
# 17，更新root用户密码
update mysql.user set authentication_string=password('qwer1234') where user='root' and Host = 'localhost';
flush privileges;
# 设置mysql root密码：
alter user 'root'@'localhost' identified by 'Root!!2018';  
# 18，清空数据表
truncate table tablename;
delete from tablename where id=0;
# 19，删除有外键约束的数据
SET FOREIGN_KEY_CHECKS=0;  #  禁用外键约束
SET FOREIGN_KEY_CHECKS=1; #  启动外键约束
# 20，重置密码：
#编辑mysql配置文件/etc/my.cnf,添加"skip-grant-tables"
/etc/init.d/mysql restart
#连接mysql，直接回车即可，不需要输入密码
mysql -u root -p
#更新root用户密码
update mysql.user set authentication_string=password('') where user='root' and Host = 'localhost';
#刷新权限
flush privileges;
#推出mysql
exit 

# 导出数据库
datetime=`date '+%Y%m%d%H%M%S'`
mysqldump -u chat -pqq214220175 chat > /tmp/chat$datetime.sql

关闭|开启MySQL命令：

mysqladmin -uroot -p shutdown  # 关闭

mysqld_safe & # 开启

#创建表：
CREATE TABLE `user_info` (
  `id` int(32) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8; 


# 扩容分布式云数据库：https://cloud.google.com/spanner/?hl=zh-cn
慢查询配置：https://www.cnblogs.com/kerrycode/p/5593204.HTML
数据库监控Percona：https://blog.csdn.net/wh211212/article/details/72190471
java监控Springboot数据库：https://www.cnblogs.com/s6-b/p/11378576.html

INSERT INTO repositories_members (createdAt, updatedAt, repositoryId, userId) VALUES (NOW(),NOW(),"", "100000028");