#!/bin/bash
# ��������mongoDB����
mongo_username="zdhyw" # mongodb�Զ����û���
mongo_password="a5568bb6163eecaa52bbdd79a98bf65b" # mongodb�Զ�������
mongodump="/usr/local/mongodb/bin/mongodump" # mongodumpִ��·��
mongo_port=20000 # mongodb�����˿�
mongo_database="zdhyw" # mongodb���ݿ���
datetime=`date '+%Y%m%d%H%M%S'`
mkdir -p /tmp/zdhyw_mongodb_data_$datetime/
$mongodump -h 127.0.0.1:$mongo_port -u $mongo_username  -p $mongo_password -d $mongo_database -o /tmp/zdhyw_mongodb_data_$datetime/
