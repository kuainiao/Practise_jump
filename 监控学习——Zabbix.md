
yum install -y wget net-tools
yum install -y httpd mariadb-server mariadb php php-mysql php-gd libjpeg* php-ldap php-odbc php-pear php-xml php-xmlrpc php-mhash php-mbstring php-bcmath
vi /etc/httpd/conf/httpd.conf
#######################################
<IfModule dir_module>
    DirectoryIndex index.html index.php
</IfModule>
#######################################

vi /etc/php.ini
#######################################
[Date]
date.timezone = PRC
#######################################

systemctl stop firewalld.service
setenforce 0
systemctl start httpd.service
systemctl start mariadb.service

mysql_secure_installation

mysql -u root -p
#######################################
CREATE DATABASE zabbix character set utf8 collate utf8_bin;
GRANT all ON zabbix.* TO 'zabbix'@'%' IDENTIFIED BY 'qwer1234';
flush privileges;
#######################################

rpm -ivh https://mirrors.tuna.tsinghua.edu.cn/zabbix/zabbix/4.0/rhel/7/x86_64/zabbix-release-3.5-1.el7.noarch.rpm

yum install zabbix-server-mysql zabbix-web-mysql -y

zcat /usr/share/doc/zabbix-server-mysql-4.0.0/create.sql.gz | mysql -uzabbix -p -h 127.0.0.1 zabbix  

cat >> /etc/zabbix/zabbix_server.conf << EOF
LogFile=/var/log/zabbix/zabbix_server.log
LogFileSize=0
PidFile=/var/run/zabbix/zabbix_server.pid
SocketDir=/var/run/zabbix
DBHost=127.0.0.1
DBName=zabbix
DBUser=zabbix
DBPassword=qwer1234
SNMPTrapperFile=/var/log/snmptrap/snmptrap.log
Timeout=4
AlertScriptsPath=/usr/lib/zabbix/alertscripts
ExternalScripts=/usr/lib/zabbix/externalscripts
LogSlowQueries=3000
EOF


cat >> /etc/httpd/conf.d/zabbix.conf << EOF
Alias /zabbix /usr/share/zabbix
<Directory "/usr/share/zabbix">
    Options FollowSymLinks
    AllowOverride None
    Require all granted
    <IfModule mod_php5.c>
        php_value max_execution_time 300
        php_value memory_limit 128M
        php_value post_max_size 16M
        php_value upload_max_filesize 2M
        php_value max_input_time 300
        php_value max_input_vars 10000
        php_value always_populate_raw_post_data -1
        php_value date.timezone Asia/Shanghai
    </IfModule>
</Directory>
<Directory "/usr/share/zabbix/conf">
    Require all denied
</Directory>
<Directory "/usr/share/zabbix/app">
    Require all denied
</Directory>
<Directory "/usr/share/zabbix/include">
    Require all denied
</Directory>
<Directory "/usr/share/zabbix/local">
    Require all denied
</Directory>
EOF

systemctl enable zabbix-server
systemctl start zabbix-server

netstat -lnpt | grep zabbix 

systemctl restart httpd.service

rpm -ivh http://repo.zabbix.com/zabbix/3.5/rhel/7/x86_64/zabbix-release-3.5-1.el7.noarch.rpm
yum install -y zabbix-agent
cat >> /etc/zabbix/zabbix_agentd.conf << EOF
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Server=127.0.0.1
ServerActive=127.0.0.1
Hostname=Zabbix server
Include=/etc/zabbix/zabbix_agentd.d/*.conf
EOF
service firewalld stop
setenforce 0
systemctl enable zabbix-agent.service
systemctl restart zabbix-agent.service
netstat -anpt | grep zabbix


# 访问 http://118.89.23.220/zabbix，账号：Admin，密码：zabbix


参考笔记：https://blog.imdst.com/zabbix-jian-kong-tian-jia-jian-kong-fu-wu-qi/

1，官方中文文档：https://www.zabbix.com/documentation/3.4/zh/manual/
2，安装php环境：https://github.com/easonjim/centos-shell/blob/master/php/install-php_5.6.13.sh
3，安装apache环境：

安装Apache
yum install httpd httpd-devel -y

设置开机启动并启动apache
systemctl enable httpd
systemctl start httpd

重启apache
systemctl restart httpd

修改apache配置支持php

修改apache配置文件httpd.conf
AddType application/x-httpd-php .php .phtml
AddType application/x-httpd-php-source .phps  <--添加两行，php结尾的交给php处理，不添加这两行apache解析不了php

安装zabbix_server
安装zabbix所需的组件(server,agent) 
yum -y install libdbi-dbd-mysql libcurl-devel net-snmp net-snmp-devel libxml2 libxml2-devel

创建zabbix用户组与用户:
groupadd zabbix
useradd -g zabbix -s /sbin/nologin zabbix

解压：
tar xf zabbix-3.2.4.tar.gz
cd zabbix-3.2.4
 yum install libevent-devel -y
yum -y install pcre*
yum -y install mysql-devel
./configure --prefix=/usr/local/zabbix --enable-server --enable-agent --with-mysql --enable-ipv6 --with-net-snmp --with-libcurl --with-libxml2make
make install

导入数据库sql脚本：
cd zabbix-3.2.4/database/mysql/
mysql -uzabbix -pzabbix zabbix < schema.sql
mysql -uzabbix -pzabbix zabbix < images.sql
mysql -uzabbix -pzabbix zabbix < data.sql

修改配置文件并启动：
mkdir -p /var/www/html/zabbix
cd /usr/local/src/zabbix-3.2.4
cp -a frontends/php/* /var/www/html/zabbix

cd /usr/local/zabbix-server/etc
修改zabbix配置，主要是zabbix数据库用户名和密码的设定：
cd /etc/zabbix/
vim zabbix_server.conf
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=zabbix

修改PHP相关参数
#vi /etc/php.ini
max_execution_time = 300
max_input_time = 300
memory_limit = 128M
post_max_size = 32M
date.timezone = Asia/Shanghai

设置开机启动并启动zabbix-server
cd /lib/systemd/system/
vim zabbix_server.server
[Unit]
Description=The Zabbix Server
#After=network.target remote-fs.target nss-lookup.target
Documentation=man:zabbix
Documentation=man:zabbixctl(8)

[Service]
Type=notify
EnvironmentFile=/usr/local/zabbix-server/etc/zabbix_server.conf
ExecStart=/etc/init.d/zabbix_server start
ExecReload=/etc/init.d/zabbix_server restart
ExecStop=/bin/kill -WINCH ${MAINPID}
# We want systemd to give httpd some time to finish gracefully, but still want
# it to kill httpd after TimeoutStopSec if something went wrong during the
# graceful stop. Normally, Systemd sends SIGTERM signal right after the
# ExecStop, which would kill httpd. We are sending useless SIGCONT here to give
# httpd time to finish.
KillSignal=SIGCONT
PrivateTmp=true

[Install]
WantedBy=multi-user.target

cp /usr/local/src/zabbix-3.2.4/misc/init.d/tru64/zabbix_server /etc/init.d/
修改安装路径
vim /etc/init.d/zabbix_server
DAEMON=/usr/local/zabbix-server/sbin/zabbix_server

启动zabbix_server
systemctl start zabbix_server

页面登录zabbix
 

报错：
PHP bcmath extension missing (PHP configuration parameter --enable-bcmath).
解决：
yum install *bcmath* -y
然后在 /etc/php.ini 文件里，添加： 
extension=bcmath.so
重启httpd
systemctl restart httpd


