Ubuntu����ʹ�ü��ɣ�

#��������ǽ������22�˿�
ufw enable
ufw allow 22
uft status

vi /etc/ssh/sshd_config
UseDNS no #��ʹ��dns����
GSSAPIAuthentication no #�������Ľ������
service sshd restart

mv /etc/apt/sources.list /etc/apt/sources.list.bak  # aptԴ����ǰ������б���
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

