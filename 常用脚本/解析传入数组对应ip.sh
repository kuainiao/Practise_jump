#!/bin/bash
# 传参规则：IP 数组 账号数组 密码数组 
# 实际执行：sh test.sh "192.168.240.111 172.16.0.12" "ben lyj" "123 456" 
ip_lists=($1) # 巡检主机的 IP 地址 
username=($2) # 账号名数组 
password=($3) # 密码数组 
ipaddr=$(ip addr | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}')
ipaddr=`echo ${ipaddr} | awk '{print $1}' | head -1` # 获取本机 IP 地址 
echo "ip : $ipaddr" 
IFS=' ' # 传参数组空格分隔符 
declare -i i=0 
declare -i i2=0 
declare -i i3=0 
locate=-2 
for v in ${ip_lists[@]} 
do 
if [ $v == $ipaddr ] 
then
locate=$i 
fi 
for v2 in ${username[@]} 
do 
locate2=`expr $locate \* 2 + 2` 
locate2=`expr $locate2 - 1` 
if [ $i2 == $locate2 ] 
then 
echo "username : $v2" # 输出取到本机的账户名 
fi
for v3 in ${password[@]} 
do 
locate3=`expr $locate \* 3 + 3` 
locate3=`expr $locate3 - 1` 
if [ $i3 == $locate3 ] 
then
echo "password : $v3" # 输出取到本机的密码 
fi
i3+=1 
done 
i2+=1 
done 
i+=1 
done