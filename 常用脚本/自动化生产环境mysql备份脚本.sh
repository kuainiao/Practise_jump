#!/bin/bash
# ��������mysql����
mysqldump_path="mysqldump" # mysqldumpִ��·��
mysql_username="ioszdhyw" # mysql �Զ����û���
mysql_passwd="Tan@!0164;" # mysql �Զ�������
datetime=`date '+%Y%m%d%H%M%S'`
mkdir -p /tmp/zdhyw_mysql_data_$datetime/
$mysqldump_path -u $mysql_username -p$mysql_passwd aomm > /tmp/zdhyw_mysql_data_$datetime/aomm.sql
$mysqldump_path -u $mysql_username -p$mysql_passwd aomm_account > /tmp/zdhyw_mysql_data_$datetime/aomm_account.sql
$mysqldump_path -u $mysql_username -p$mysql_passwd aomm_compliance > /tmp/zdhyw_mysql_data_$datetime/aomm_compliance.sql
$mysqldump_path -u $mysql_username -p$mysql_passwd aomm_filestore > /tmp/zdhyw_mysql_data_$datetime/aomm_filestore.sql
$mysqldump_path -u $mysql_username -p$mysql_passwd aomm_inspection > /tmp/zdhyw_mysql_data_$datetime/aomm_inspection.sql
$mysqldump_path -u $mysql_username -p$mysql_passwd aomm_softdeploy > /tmp/zdhyw_mysql_data_$datetime/aomm_softdeploy.sql
$mysqldump_path -u $mysql_username -p$mysql_passwd aomm_startstop > /tmp/zdhyw_mysql_data_$datetime/aomm_startstop.sql