﻿0，定义一个变量：  #   str="hello"
   输出打印变量：  #   echo  $str  ;  echo ${str}
   
基础命令：
ls  ————列出当前目录内容命令
cd  ————打开目录命令
pwd ————列出当前目录命令
find ———— 查找文件命令
cut ———— 分隔字符串
                                echo "12:34:56:23" | cut -d: -f2  #  获取":"符号的第二次出现后跟着的字符串
cat ————输出文件内容命令 ：     cat a.txt
head ———输出前n行文件内容命令： cat a.txt | head -2
wc  ————统计文件行数命令：      cat a.txt | wc -l
sort ———每行排序命令：          cat a.txt | sort -rn #  降序排列
                                cat a.txt | sort -n  #  升序排列 
uniq ————内容去重命令：         cat a.txt | uniq
grep ————输出过滤关键词命令
#  cat a.txt |  grep "abc"  # 只列出含有"abc"的内容
#  cat a.txt |  grep -v "abc"  # 列出不含有"abc"的内容
#  cat a.txt |  grep -E "ab*"  # 列出"ab"开头的内容
#  grep -rn "cc" a.txt         # 获取含有"cc"的行数
sed  ————文本处理命令
sed命令删除文件中含有“abc”的一行
#  sed -i -e '/abc/d' /etc/exports
sed命令获取含有“abc”的行数
#  sed -n -e '/abc/='  shit.txt
sed命令插入“rrr”到第2行前面
#  sed '2 irrr' -i shit.txt
sed命令插入“rrr2”到第2行后面
#  sed '2 arrr2' -i a.txt
awk  ————行运算命令

开放防火墙端口命令
#  centos6 iptables用法：
#  vi /etc/sysconfig/iptables
#  -A INPUT -p tcp -m state --state NEW -m tcp --dport 8888 -j ACCEPT
#  service iptables restart

#  centos7 firewalld用法：
#  firewall-cmd --zone=public --add-port=8888/tcp --permanent    
#  firewall-cmd --reload

压缩解压命令：
# 解压tar包到指定目录： tar -xzvf a.tgz -C /usr/local/
# 压缩文件夹tar.gz：tar zcvf 文件名.tar.gz 待压缩的文件名
  
1，追加写入文件尾部 ： #  echo "123" >> a.txt
   重写文件头部：      #  echo "123" > a.txt

2，执行命令并把命令返回内容放入pid变量：
#   pid=`ls -l`  
#   echo $pid

3，获得出现某字符串的文件第几行：#   grep -rn 'abc'  a.txt

4，sed在第3行插入文件字符串“abc”：# sed -i "3iabc"  a.txt

5，sed删除文件所有的含有字符串“abc”的行： #  sed  -i  '/abc/d'  a.txt

6，截取符号左边的字符串：#   ${变量名%符号*}

7，截取符号右边的字符串：#   ${变量名#*符号}

8，屏蔽所有命令行输出的告警：#  cat  >> /dev/null 2>&1

9，强转字符串为整型：#   pid=123  ;   pid=`echo ${pid}| awk '{print int($0)}'`

10，计算浮点数保留2位小数：#   awk 'BEGIN{printf "%.2f\n",('1244'/'3'*100)}'

11，计算整型运算： #   expr 1 + 3945

12,  终端传输文件命令：#  yum install lrzsz  # 安装 sz 命令
                       #  sz /root/a.txt       # 下载 /root/a.txt 到 Windows本地
                       #  rz    #   上传文件到 Linux 当前目录

13，两台机之间发送文件：
#   scp jdk-8u152-linux-x64.rpm root@192.168.244.148:/root
#   发送文件到192.168.244.148的/root目录

14，生成随机密码工具mkpasswd：
#  yum -y install expect
#  mkpasswd -l 15 -d 3 -C 5  #  生成长度15  至少3个数字  5个大写字母
#  生成Linux密码的8种方法：https://linux.cn/article-9318-1.html

15，后台运行程序不占用终端并记录运行日志： nohup  sh test.sh  &

16，if条件比较（整数比较）
-eq     等于,如:if ["$a" -eq "$b" ]
-ne     不等于,如:if ["$a" -ne "$b" ]
-gt     大于,如:if ["$a" -gt "$b" ]
-ge    大于等于,如:if ["$a" -ge "$b" ]
-lt      小于,如:if ["$a" -lt "$b" ]
-le      小于等于,如:if ["$a" -le "$b" ]
<  小于(需要双括号),如:(("$a" < "$b"))
<=  小于等于(需要双括号),如:(("$a" <= "$b"))
>  大于(需要双括号),如:(("$a" > "$b"))
>=  大于等于(需要双括号),如:(("$a" >= "$b"))

17，特殊符号输出： echo "\$ \""

#########################比较大小#########################
errorTimes=4
if [ $errorTimes -gt 5 ];then
     echo ">5"
else
     echo "<=5"
fi
#########################比较大小#########################
a=1
b=5
if (("$a" >= "$b"));then
    echo "a>=b"
else
    echo "a<b"
fi

17，$符号的用法
$0 这个程式的执行名字
$n 这个程式的第n个参数值，n=1..9
$* 这个程式的所有参数,此选项参数可超过9个。
$# 这个程式的参数个数
$$ 这个程式的PID(脚本运行的当前进程ID号)
$! 执行上一个背景指令的PID(后台运行的最后一个进程的进程ID号)
$? 执行上一个指令的返回值 (显示最后命令的退出状态。0表示没有错误，其他任何值表明有错误)
$- 显示shell使用的当前选项，与set命令功能相同
$@ 跟$*类似，但是可以当作数组用

18，规定8次for循环  #
for i in {1..8};do
    echo $i
done

19，while循环读取命令返回每行(逐行读取遍历txt文件)  #
cat /data/a.txt | while read a
do 
    echo $a; 
done

19，
#查看firewalld防火墙规则：
firewall-cmd --list-services
#更新firewalld规则：
firewall-cmd --reload
#开启80端口
firewall-cmd --zone=public --add-port=80/tcp --permanent 
#删除80端口
firewall-cmd --zone=public --remove-port=80/tcp --permanent
#查看状态：
systemctl status firewalld.service
#禁止特定ip连接：
firewall-cmd --permanent --zone=public --add-rich-rule="rule family='ipv4' source address='192.168.225.1' service name='ssh' reject"
firewall-cmd --permanent --zone=public --add-rich-rule="rule family='ipv4' source address='192.168.225.1' port port=22 protocol=tcp reject"
firewall-cmd --reload

20，判断命令是否执行成功
$? == 0  # 成功
$? != 0  # 失败

21，获取字符串长度： #  str="439584" ; echo ${#str} ;

22，从第2位开始截取长度为4的字符串： #  str="acbcdefgh" ; echo ${str:2:4}

23，遍历字符串：# 
str="439584"
for ((i=0;$i<=${#str};i=$i+1));  # 提取用户名
do
    echo  ${str:$i:1}
done

遍历数组：
dba_user="";
for(( i=0;i<${#text[@]};i++)) do
dba_user=$dba_user','${text[i]}
done;

24，判断字符串是否一致： #
str1="abc"
if [ $str1 != "abc" ]
then
    echo "1"
else
    echo "0"
fi

25，判断字符串是否为空（非空）： #
str=""
if [ ! -z $str ]  #  非空判断：if [ ! -z $str ]
then
    echo "1"
else
    echo "0"
fi

26，判断文件路径和文件是否存在： #
if [ -f "/data/a.txt" ]  # 判断文件存在
then
    echo "1"
fi
if [ -d "/data/filename/" ] # 判断文件夹存在
then
    echo "1"
fi

27，or 语句 ：#
if [ -f "/data/filename" ] || [ -d "/data/filename/" ]
then
    echo "1"
fi

28，and 语句 ：#
if [[ -f "/data/a.txt" && -d "/data/filename/" ]]
then
    echo "1"
fi

29，创建软连接： #  创建软链接 : ln -s 本地文件 链接路径
ln -s /data/a.txt /data/a_link

30，自动创建用户密码
username=lyj
password=123456
echo "${password}" | passwd ${username} --stdin> /dev/null 2>&1

31，查看centos（redhat）系统版本   #
version=`uname -a`
version=${version#*el}
version=${version:0:1}

32，自动编辑文本并输入：
cat > a.txt << EOF
1234567
EOF

33，查询rpm包安装路径：
rqm -qa | grep jenkins
rpm -ql jenkins-2.176.3-1.1.noarch

34，编辑当前用户的环境变量
[gitlab-runner@localhost ~]#vi ~/.bash_profile
末尾加上内容：PATH="$HOME/.local/bin:$PATH"
[gitlab-runner@localhost ~]#source ~/.bash_profile

命令返回放入数组:
text=($($sqlplus_path -s $USER/$PASSWD << EOF
EOF
))
echo ${text[0]}

33，批量杀进程：  # 
ps -aux | grep mongo | grep -v grep | cut -c 7-15 | xargs kill -9 或 pkill -9 java

34，文件
#  stat a.txt   # 列出当前文件的详细修改信息
#  md5sum test.py    # 获取文件md5值
#  sha1sum test.py   # 获取文件sha1值
#  sha256sum test.py # 获取文件sha256值

35，获取当前系统时间： # date

36，过滤只剩下数字：echo "afdw34r45t" | tr -cd  "[0-9]"
                    echo "afdw34r45t" | tr a-z A-Z      # 把小写字母转换成大写字母

37，将DOS格式文本文件转换成UNIX格式：  #  dos2unix  a.txt

38，查看端口监听情况：netstat -lntp

39，列出当前tty登陆： #  w

40，锁定用户密码 ： usermod -L lyj

41，查看CPU核数：cat /proc/cpuinfo

42，忽略证书下载： wget --no-check-certificat

43，查看当前目录占用大的文件：du -sh

Linux时间格式化输出：date "+%Y-%m-%d %H:%M:%S"

44，本地挂载iso镜像到/mnt做yum源：
cat> /etc/yum.repos.d/Server.repo <<EOF
[Server]
name=MyRPM
baseurl=file:///mnt
enabled=1
gpgcheck=0
EOF
mount -o  loop /data/soft/rhel-server-7.2-x86_64-dvd.iso /mnt
yum clean all  #  清除yum缓存

制作iso本地镜像挂载
mount -o  loop /root/rap2/CentOS-7-x86_64-Minimal-1810_2.iso /mnt
cat> /etc/yum.repos.d/Server.repo <<EOF
[Server]
name=MyRPM
baseurl=file:///mnt
enabled=1
gpgcheck=0
EOF
yum clean all

制作nginx yum源：


44，在CentOS 7上安装Node.js的4种方法：https://www.cmswing.com/p/407.html

45，列出目录里面所有隐藏文件：ls -a

46，逗号分割字符串awk方法：str='redis,nginx,mysql'
server=`echo ${str}|awk -F "[,]" '''{for(i=1;i<=NF;i++){print $i}}'''`
for i in ${server[@]}  
do
    echo $i
    num=`expr $num + 1`
done  

47，i++的效果： num=`expr $num + 1`

48，变量截取-数字前面的：name="${i%%-[0-9]*}"

49，遍历数组：
server=`echo ${str}|awk -F "[,]" '''{for(i=1;i<=NF;i++){print $i}}'''`
for i in ${server[@]}  
do
    echo $i
    num=`expr $num + 1`
done  

50，遍历命令输出多行：
diskname=`fdisk -l | grep "Disk" |grep "sectors" | awk '{print $2}' | sed 's/://g'`
for  disk_name  in  ${diskname[*]}
do
    diskuuid=$diskuuid`blkid $disk_name | grep -v "PTTYPE" | awk '{print $2}' | sed 's/UUID="//g'| sed 's/"//g'`","
done

*******************   12，yum下载本地依赖包
yum install --downloadonly --downloaddir=/root/  boost-devel.x86_64
rpm卸载：rpm -e 包名 --nodeps
rpm查询：rpm -qa
rpm安装: rpm -ivh 包名
rpm升级：rpm -Uvh 包名
rpm忽略依赖包：--nodeps
yum清除缓存：yum clean all
yum安装rpm包不带公钥：yum install -y 包名 --nogpgcheck

45，centos服务定义：https://www.cnblogs.com/wang-yc/p/8876155.html

46，grep正则排除注释行和空行：grep -Ev '^$|#' /etc/ssh/sshd_config

47，配置ssh免密登陆：
ssh-keygen -t rsa
ssh-copy-id -i ~/.ssh/id_rsa.pub  root@192.168.225.193
# 192.168.225.193执行
chmod 600 /root/.ssh/authorized_keys

48，格式化输出日期：
date "+%Y%m%d%H%M%S"

49，报nolog错误                                                                            
cat /etc/passwd 改成 /bin/bash_profile

50，host阻止其他主机登陆 /etc/host.deny
all:10.92.*.*:aloow

51，iptables防火墙规则：

52，firewalld防火墙规则：

53，selinux防火墙规则：                        

******************** 12，修改中文语言集
vi /etc/locale.conf
LANG="en_US.UTF-8"
source /etc/locale.conf
locale # 列出当前字符集合

******************** 12，显示隐藏文件
ls -a

********************  13，yum制作离线源
yum install createrepo
createrepo /home/cepuser/yumrepo

mkdir -p /etc/yum.repos.d/bak
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/bak
cat > /etc/yum.repos.d/local.repo << EOF
[local]
name=local
baseurl=file:///home/cepuser/yumrepo
gpgcheck=1
enabled=1
EOF
yum clean all

rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

**********************  14 , 配置yum扩展阿里源
rm -rf /etc/yum.repos.d/*.repo
wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
sed -i '/aliyuncs/d' /etc/yum.repos.d/CentOS-Base.repo
sed -i '/aliyuncs/d' /etc/yum.repos.d/epel.repo
sed -i 's/$releasever/7/g' /etc/yum.repos.d/CentOS-Base.repo
yum clean all
yum makecache

# yum源换阿里源
mkdir -p /etc/yum.repos.d/defaul
cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/default
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum clean all
yum makecache

**********************  15，升级Redhat yum源

rpm -Uvh rpm-4.11.3-40.el7.x86_64.rpm --nodeps
http://mirrors.163.com/centos/7/os/x86_64/Packages/yum-3.4.3-163.el7.centos.noarch.rpm
http://mirrors.163.com/centos/7/os/x86_64/Packages/python-iniparse-0.4-9.el7.noarch.rpm
http://mirrors.163.com/centos/7/os/x86_64/Packages/yum-plugin-fastestmirror-1.1.31-52.el7.noarch.rpm
http://mirrors.163.com/centos/7/os/x86_64/Packages/yum-metadata-parser-1.1.4-10.el7.x86_64.rpm
rpm -aq|grep yum|xargs rpm -e --nodeps 
rpm -aq|grep mongo|xargs rpm -e --nodeps 
rpm -ivh python-iniparse-0.4-9.el7.noarch.rpm
rpm -ivh yum-metadata-parser-1.1.4-10.el7.x86_64.rpm
sed -i 's/$releasever/7/g' /etc/yum.repos.d/CentOS-Base.repo
yum clean all

16，更改主机hostname：hostnamectl set-hostname 新主机名

**********************  15，配置NFS：
#  主机配置nfds临时挂载
yum install -y nfs-utils   # 安装nfs权限
mkdir -p /data/soft/
cat >> /etc/exports << EOF
/data/soft/ 192.168.50.229 (rw,no_root_squash,async)
*(rw,no_root_squash,async,insecure)代表所有主机
EOF
service nfs start

#  从机临时挂载
mkdir -p /mnt
mount -t nfs 192.168.50.229:/data/soft/ /mnt
cp -r /tmp/soft/jdk-8u152-linux-x64.rpm /data/soft/
umount /tmp/soft

#  主机强行卸载nfs
umount -l /tmp/soft

# 主机删除nfds临时挂载
sed -i -e '/192.168.240.113/d' /etc/exports
service nfs restart

# 
dba_user="";
for(( i=0;i<${#text[@]};i++)) do
dba_user=$dba_user','${text[i]}
done;

**********************  Redhat系统去掉yum注册

vim /etc/yum/pluginconf.d/subscription-manager.conf

yum安装rpm依赖包 ： yum -y install xxxx.rpm

vim 快速到最后一行:   :$

开机启动服务：systemctl enable docker
开机启动服务：chmod 755 /etc/init.d/mysql​
​chkconfig --add mysql
​chkconfig --level 2345 mysql on



**********************  16，CentOS初始优化
vi /etc/sysconfig/network-scripts/ifcfg-enp0s3
ONBOOT YES
service network restart
# 关闭防火墙
cat  >> /etc/sysconfig/selinux  << EOF
SELINUX=disabled
EOF
# centos7防火墙增加22端口
firewall-cmd --zone=public --add-port=22/tcp --permanent
firewall-cmd --reload
# centos6防火墙增加22端口
vi /etc/sysconfig/iptables
-A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
service iptables restart
# ssh 连接速度优化：
vi /etc/ssh/sshd_config
UseDNS no #不使用dns解析
GSSAPIAuthentication no #连接慢的解决配置
service sshd restart
# 基础软件
yum -y update
yum install -y net-tools wget unzip
# yum源换阿里源
mkdir -p /etc/yum.repos.d/defaul
cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/default
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
sed -i  's/$releasever/7/g' /etc/yum.repos.d/CentOS-Base.repo
yum clean all
yum makecache
# yum换上扩展源
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
sed -i  's/$releasever/7/g' /etc/yum.repos.d/CentOS-Base.repo
wget -P /etc/yum.repos.d/ http://mirrors.aliyun.com/repo/epel-7.repo
yum clean all
yum makecache
yum install epel-release
# 内核优化
cat >>/etc/sysctl.conf<<EOF
net.ipv4.tcp_fin_timeout = 2
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_keepalive_time = 600
net.ipv4.ip_local_port_range = 4000 65000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 36000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.core.somaxconn = 16384
net.core.netdev_max_backlog = 16384
net.ipv4.tcp_max_orphans = 16384
EOF
sysctl -p
# ntp时间同步：
yum install -y ntpdate
yes | cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ntpdate us.pool.ntp.org
crontab -l >/tmp/crontab.bak
echo "10 * * * * /usr/sbin/ntpdate us.pool.ntp.org | logger -t NTP" >> /tmp/crontab.bak
crontab /tmp/crontab.bak
date

# 手动修改系统时间
date -s "20200413 09:27:00"

# 获取ntp时间服务偏差：
ntpdate -q us.pool.ntp.org | grep "offset*.*sec"|awk '{print $(NF-1)}'|head -1

# 添加定时任务
crontab -e
* * * * * /usr/sbin/ntpdate us.pool.ntp.org    # 分，时 ，日，周，月

# 给用户授权某个目录
chown -R mysql:mysql /var/lib/mysql/

1，bind_ip 为 0.0.0.0 才能外部访问
2，ssh速度优化：cat /etc/ssh/sshd_config | grep -v "#"
UseDNS no
GSSAPIAuthentication no

3，shell四则运算和保留浮点数小数位：
9，强转字符串为整型：#   pid=123  ;   pid=`echo ${pid}| awk '{print int($0)}'`

传入超过10个参数：${10}
/dev/null无权限：rm -f /dev/null && mknod -m 0666 /dev/null c 1 3

1，或条件语句：  if [ $aaa -eq 0 -o $bbb -eq 0 ];then
2，与条件语句：  if [ $aaa -eq 0 -a $bbb -ne 0 ];then
3，判断文件存在：if [ -f $conf_path];then
4，避免字符串为空报错：if [ x"$operation" == x"UpdateUser" ]
5，定义方法返回：# 返回结果函数
function result(){
    echo "{'$1':{'value':$2,'unit':$3,'status':$4}}"
}
6，往方法传入参数调用：方法名  参数1（$1）  参数2  参数3  参数4
7, 取路径/的前面路径，取路径部分：start_file="${conf_file%/*}"

10，shell四则运算计算1244/3*100浮点数保留2位小数的两种方法：
[root@master ~]# echo "scale=4; 1244/3*100" | bc
41466.6600
[root@master ~]# awk 'BEGIN{printf "%.4f\n",('1244'/'3'*100)}' # 提倡awk，因为精确
41466.6667

awk分割取第三列：awk '{printf $3}'

11，时间修正
yum install -y ntpdate
yes | cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ntpdate us.pool.ntp.org
date
crontab -l >/tmp/crontab.bak
echo "*/10 * * * * /usr/sbin/ntpdate us.pool.ntp.org | logger -t NTP" >> /tmp/crontab.bak
crontab /tmp/crontab.bak

12，查询

邮件发送：
yum install -y mailx
cat >> /etc/mail.rc <<EOF
####################################
set bsdcompat
set smtp-use-starttls 
set from="1290851757@qq.com"
set smtp="smtps://smtp.qq.com:465"
set smtp-auth-user="1290851757@qq.com"
set smtp-auth-password="nzqygrzwccgpiejb"
set smtp-auth=login
set ssl-verify=ignore
set nss-config-dir=/etc/pki/nssdb
####################################
EOF

echo "邮件内容" | mail -v -q -s "邮件标题" -r 1290851757@qq.com -S smtp-auth=login -S smtps://smtp.qq.com:465 -S smtp-auth-user="1290851757@qq.com" -S smtp-auth-password="nzqygrzwccgpiejb" 1755337994@qq.com

13，是否包含子字符串：
strA="long string"
strB="string"
result=$(echo $strA | grep "${strB}")
echo $result


14,彻底关闭防火墙：
vi /etc/selinux/config
SELINUX=disabled
#SELINUXTYPE=targeted

15，替换字符串的空格
echo "1    2  3 4    5     6"|sed 's/ //g'

setenforce 0

15，查看索引节点：df -i
cd /var/spool/postfix/maildrop
ls | xargs -n 100 rm -rf 

16，删除索引数量已满的文件命令：
find . -type f -mtime +7 -delete

17，新建多个文件夹：mkdir -p {aa,bb,cc}

18，实时看文件输出变化：tailf 文件名

19，压缩文件夹：
tar zcvf 压缩包文件名.tar.gz 需要压缩的文件名

20，时间写入硬件
hclock -w

21，获取文件或文件夹权限：stat /usr/local/mysql/bin/  |head -n4|tail -n1|cut -d "/" -f1

1，查看系统用户：cat /etc/passwd|grep -v nologin|grep -v halt|grep -v shutdown|grep -v sync|grep -v syslog|awk -F":" '{ print $1 }'|more
2，检测密码过期时间：chage -l root | grep "Password expires" | awk -F ": " '{ print $2 }'
3，查看root用户过期时间：chage -l root
4，设置密码有效期：chage -d 0 -m 0 -M 180 -W 15 root

linux查看内核信息：  lsmod

sar命令查看系统瓶颈和历史负载：
https://shockerli.net/post/linux-tool-sar/#i-o-%E5%92%8C%E4%BC%A0%E8%BE%93%E9%80%9F%E7%8E%87%E4%BF%A1%E6%81%AF%E7%8A%B6%E5%86%B5

22，查看网络端口连接情况：netstat -an

23，替换回车符

查看用户密码最小长度：cat /etc/login.defs| grep -Ev "^$|#" | grep PASS_MIN_LEN

24，以日期命名文件： /etc/rsyslog.conf.$(date +%F)