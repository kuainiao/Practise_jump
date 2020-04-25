#!/bin/bash
# 生产环境mysql备份
mysqldump_path="mysqldump" # mysqldump执行路径
mysql_username="ioszdhyw" # mysql 自动化用户名
mysql_passwd="Tan@!0164;" # mysql 自动化密码
datetime=`date '+%Y%m%d%H%M%S'`
mkdir -p /tmp/zdhyw_mysql_data_$datetime/
$mysqldump_path -u $mysql_username -p$mysql_passwd aomm > /tmp/zdhyw_mysql_data_$datetime/aomm.sql
$mysqldump_path -u $mysql_username -p$mysql_passwd aomm_account > /tmp/zdhyw_mysql_data_$datetime/aomm_account.sql
$mysqldump_path -u $mysql_username -p$mysql_passwd aomm_compliance > /tmp/zdhyw_mysql_data_$datetime/aomm_compliance.sql
$mysqldump_path -u $mysql_username -p$mysql_passwd aomm_filestore > /tmp/zdhyw_mysql_data_$datetime/aomm_filestore.sql
$mysqldump_path -u $mysql_username -p$mysql_passwd aomm_inspection > /tmp/zdhyw_mysql_data_$datetime/aomm_inspection.sql
$mysqldump_path -u $mysql_username -p$mysql_passwd aomm_softdeploy > /tmp/zdhyw_mysql_data_$datetime/aomm_softdeploy.sql
$mysqldump_path -u $mysql_username -p$mysql_passwd aomm_startstop > /tmp/zdhyw_mysql_data_$datetime/aomm_startstop.sql