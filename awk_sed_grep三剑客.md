############################# 运算
1，强转字符串为整型：pid=`echo ${pid}| awk '{print int($0)}'`
2，计算浮点数保留2位小数：awk 'BEGIN{printf "%.2f\n",('1244'/'3'*100)}'
3，整数计算：expr 1 + 3945

############################# awk用法
1，awk分割取第三列：awk '{print $3}'
2，":"为分隔符取第一列：awk  -F ':'  '{print $2}'
3，

############################# sed用法
2，取返回的第二列：sed -n '2p'

############################# grep用法
1，grep -w "abc23"                       精确匹配
2，grep -v "abc"                         排除
3，grep -Ev '^$|#' /etc/ssh/sshd_config  排除文件的#和空行

############################# xargs用法
1，批量杀进程：ps -aux | grep httpd | grep -v grep | cut -c 7-15 | xargs kill -9 
rpm -qa | grep docker | xargs -I rpm -e {} --nodeps
############################# cut用法

sed  ————文本处理命令
sed命令删除文件中含有“abc”的一行
#  sed -i -e '/abc/d' /etc/exports
sed命令获取含有“abc”的行数
#  sed -n -e '/abc/='  shit.txt
sed命令插入“rrr”到第2行前面
#  sed '2 irrr' -i shit.txt
sed命令插入“PASS_WARN_AGE 26”到/etc/login.defs第line_number行后面
#  sed -i "$line_number"i"PASS_WARN_AGE 26" /etc/login.defs
查看最后一行的内容
#  sed -n '$p'



3，获得出现某字符串的文件第几行：#   grep -rn 'abc'  a.txt

4，sed在第3行插入文件字符串“abc”：# sed -i "3iabc"  a.txt

5，sed删除文件所有的含有字符串“abc”的行： #  sed  -i  '/abc/d'  a.txt

6，截取符号左边的字符串：#   ${变量名%符号*}

7，截取符号右边的字符串：#   ${变量名#*符号}

8，以冒号为分隔：cat /etc/passwd | awk -F "[:]"  '{print $3}'

grep -w 精确匹配
grep -v 排除
grep正则排除注释行和空行：grep -Ev '^$|#' /etc/ssh/sshd_config



