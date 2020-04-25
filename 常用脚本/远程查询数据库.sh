#!/bin/bash
dbuser=$1
dbpass=$2
ip="127.0.0.1"
port="3306"
area=$3
begintime=$4
endtime=$5
mysqlbin=/home/mysql/mariadb/bin/mysql
mysql="$mysqlbin -u $dbuser -p$dbpass -h $ip -P $port -S /home/mysql/mariadb/mysql.sock"
database_size=`$mysql -Bse "select count(*) from aomm.t_operation_task where task_create_time between '$begintime' and '$endtime';"`
echo $database_size