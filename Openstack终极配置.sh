https://www.bbsmax.com/A/VGzlbq9y5b/

1,安装pip
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

2,安装git、wget等工具
yum -y install git wget
3，配置yum源指向国内的源


yum update -y
sudo useradd -s /bin/bash -d /opt/stack -m stack
echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack
git clone https://git.openstack.org/openstack-dev/devstack
cd devstack
git checkout -b stein origin/stable/stein

mkdir -p ~/.pip/
cat > ~/.pip/pip.conf <<EOF
[global]
index-url = https://pypi.douban.com/simple
[install]
EOF

su - stack
mkdir -p ~/.pip/
cat > ~/.pip/pip.conf <<EOF
[global]
index-url = https://pypi.douban.com/simple
[install]
EOF

su - 
cd /opt/stack/devstack/
cp /opt/stack/devstack/samples/local.conf /opt/stack/devstack/
# 指向国内源trystack
vi /opt/stack/devstack/local.conf
ADMIN_PASSWORD=yourpassword
DATABASE_PASSWORD=$ADMIN_PASSWORD
RABBIT_PASSWORD=$ADMIN_PASSWORD
SERVICE_PASSWORD=$ADMIN_PASSWORD
HOST_IP=192.168.225.148
# use TryStack git mirror
GIT_BASE=http://git.trystack.cn
NOVNC_REPO=http://git.trystack.cn/kanaka/noVNC.git
SPICE_REPO=http://git.trystack.cn/git/spice/spice-html5.git
cd /opt/stack/devstack/files
wget https://storage.googleapis.com/etcd/v3.2.17/etcd-v3.2.17-linux-amd64.tar.gz

yum install libibverbs -y
chmod -R 777 /opt/stack
su - stack
cd /opt/stack/devstack/
./stack