https://www.cnblogs.com/chaofan-/p/11714741.html

1.1 系统准备

2网卡、8GB内存、40GB空间

###############################################################
1.2 关闭防火墙

sed -i 's#SELINUX=enforcing#SELINUX=disabled#g' /etc/sysconfig/selinux
setenforce 0
systemctl stop firewalld.service
systemctl disable firewalld.service

###############################################################
1.3 关闭libvirtd服务

systemctl stop libvirtd.service 
systemctl disable libvirtd.service

###############################################################
1.4 更新内核
yum -y update

###############################################################
2.1 安装docker
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum -y install docker-ce
systemctl start docker && systemctl enable docker && systemctl status docker
mkdir /etc/systemd/system/docker.service.d
tee /etc/systemd/system/docker.service.d/kolla.conf << 'EOF' 
[Service] 
MountFlags=shared 
EOF
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io  
systemctl daemon-reload
systemctl enable docker && systemctl restart docker && systemctl status docker

###############################################################
2.2 安装依赖
yum install -y git
yum install -y epel-release  
yum install -y python-pip 
pip install -U pip 
yum install -y python-devel libffi-devel gcc openssl-devel libselinux-python
yum install -y ansible

###############################################################
2.3 下载依赖
git clone https://github.com/openstack/kolla -b stable/stein
git clone https://github.com/openstack/kolla-ansible -b stable/stein

python kolla-ansible/setup.py install
pip install -r ./kolla/requirements.txt --ignore-installed PyYAML
pip install -r ./kolla-ansible/requirements.txt

yes | cp -r ./kolla-ansible/etc/kolla /etc/kolla 
yes | cp ./kolla-ansible/ansible/inventory/* .