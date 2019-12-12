Ubuntu常见使用技巧：

#启动防火墙并开放22端口
ufw enable
ufw allow 22
uft status

vi /etc/ssh/sshd_config
UseDNS no #不使用dns解析
GSSAPIAuthentication no #连接慢的解决配置
service sshd restart

mv /etc/apt/sources.list /etc/apt/sources.list.bak  # apt源更改前必须进行备份
cat > /etc/apt/sources.list << EOF
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
EOF
apt-get update
apt-get upgrade

apt-get install python3-pip

pip install -i https://pypi.tuna.tsinghua.edu.cn/simple numpy==1.13.3
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple tensorflow

