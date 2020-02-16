# 1，保持网络连接：
crontab -l >/tmp/crontab.bak
echo "10 * * * * /etc/init.d/network restart" >> /tmp/crontab.bak
crontab /tmp/crontab.bak

# 2，ntp时间同步：
yum install -y ntpdate
yes | cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ntpdate us.pool.ntp.org
crontab -l >>/tmp/crontab.bak
echo "10 * * * * /usr/sbin/ntpdate us.pool.ntp.org | logger -t NTP" >> /tmp/crontab.bak
crontab /tmp/crontab.bak
date

# 3，安装基础软件：
yum install -y wget net-tools

# 4，安装阿里源：
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
yum install -y epel-release

# 5，系统更新：
yum update -y 

# 6，关闭防火墙
setenforce 0
vi /etc/selinux/config

SELINUX=disabled
#SELINUXTYPE=targeted

systemctl stop firewalld
systemctl disable firewalld

# 7，配置ssh免密登陆：
ssh-keygen -t rsa
ssh-copy-id -i ~/.ssh/id_rsa.pub  root@192.168.50.84
chmod 600 /root/.ssh/authorized_keys
chmod 700 /home/luyanjie

8 , 安装最新版Docker
#################################################
yum -y update
yum install -y yum-utils device-mapper-persistent-data lvm2
cd /etc/yum.repos.d/
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum -y install docker-ce
systemctl start docker
systemctl enable docker
#################################################

9，安装pip
wget --no-check-certificat  https://pypi.python.org/packages/source/s/setuptools/setuptools-2.0.tar.gz
tar zxf setuptools-2.0.tar.gz
cd setuptools-2.0
python setup.py install
cd  ..
wget https://files.pythonhosted.org/packages/00/9e/4c83a0950d8bdec0b4ca72afd2f9cea92d08eb7c1a768363f2ea458d08b4/pip-19.2.3.tar.gz --no-check-certificate
tar -xzvf pip-19.2.3.tar.gz
cd pip-19.2.3
python setup.py install
python -m pip install --upgrade pip
################################

简易安装pip工具：yum install python-pip 或 curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
python get-pip.py
pip install --upgrade pip

豆瓣pip 安装加速：pip install -i http://pypi.douban.com/simple --trusted-host pypi.douban.com packagename

永久更换pip源：修改~/.pip/pip.conf文件，如果没有就创建一个，写入如下内容（以清华源为例）：
mkdir -p ~/.pip/
cat >> ~/.pip/pip.conf <<EOF
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
[install]
EOF

######################################################################################
