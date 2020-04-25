#!/bin/bash
# 生产环境mongoDB备份
mongo_username="zdhyw" # mongodb自动化用户名
mongo_password="a5568bb6163eecaa52bbdd79a98bf65b" # mongodb自动化密码
mongodump="/usr/local/mongodb/bin/mongodump" # mongodump执行路径
mongo_port=20000 # mongodb监听端口
mongo_database="zdhyw" # mongodb数据库名
datetime=`date '+%Y%m%d%H%M%S'`
mkdir -p /tmp/zdhyw_mongodb_data_$datetime/
$mongodump -h 127.0.0.1:$mongo_port -u $mongo_username  -p $mongo_password -d $mongo_database -o /tmp/zdhyw_mongodb_data_$datetime/
