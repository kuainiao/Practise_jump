#!/bin/bash
#检查检查密码是否包含大写、小写、数字、特殊字符和密码长度。
echo "dawjo77GYU&^dawjoia" > frepwd.txt
for passwd in `cat frepwd.txt`
do
  #echo $passwd
  strlen=`echo $passwd | grep -E --color '^(.{8,}).*$'`
  #密码长度是否8位以上（包含8位）
  strlow=`echo $passwd | grep -E --color '^(.*[a-z]+).*$'`
  #密码是否有小写字母
  strupp=`echo $passwd | grep -E --color '^(.*[A-Z]).*$'`
  #密码是否有大写字母
  strts=`echo $passwd | grep -E --color '^(.*\W).*$'`
  #密码是否有特殊字符
  strnum=`echo $passwd | grep -E --color '^(.*[0-9]).*$'`
  #密码是否有数字
  #-n 判断字符不为空 返回真
 if [ -n "${strlen}" ] && [ -n "${strlow}" ] && [ -n "${strupp}" ] && [ -n "${strts}" ]  && [ -n "${strnum}" ] 
  then
     echo $passwd >> newfrepwd.log
  else  
     echo $passwd >> nofrepwd.log
  fi
done