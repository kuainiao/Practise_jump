镜像安装：https://zhuanlan.zhihu.com/p/96865406

使用用户名 kolla，密码 kollapass 登录系统，并切换到 root 用户：

$ sudo -s
# cd /root
下面的所有操作都使用 root 用户执行，全程只需要执行三个命令：

下面每个命令都是执行相应的 ansible playbook，所以屏幕会有大量打印。
安装前的环境检测，检查是否必要条件都已经满足

# kolla-ansible prechecks
开始安装，视机器性能和选择安装模块数量，20分钟到40分钟不等，耐心等待即可

# kolla-ansible deploy
安装后的一点点收尾工作

# kolla-ansible post-deploy

Kolla部署：https://www.cnblogs.com/chaofan-/p/11714741.html
        https://xuchao918.github.io/2018/05/07/%E5%A6%82%E4%BD%95%E8%8E%B7%E5%8F%96Kolla%E7%9A%84OpenStack%E9%95%9C%E5%83%8F/
		

192.168.225.194	计算节点	compute1
192.168.225.193	control节点	control


# 1，域名解析和关闭防火墙(全部执行)
############################################################################
cat > /etc/hosts << EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.225.193 control11      
192.168.225.194 compute1
EOF
sed -i 's#SELINUX=enforcing#SELINUX=disabled#g' /etc/sysconfig/selinux
setenforce 0
systemctl stop firewalld.service
systemctl disable firewalld.service

# 设置主机名 192.168.225.193
hostnamectl set-hostname control11
# 设置主机名 192.168.225.194
hostnamectl set-hostname compute1


# 2，（在controller、cinder、computer节点配置）安装
yum install python-devel libffi-devel gcc openssl-devel git python-pip -y
pip install -U pip 
yum install -y yum-utils device-mapper-persistent-data lvm2
yum install -y ansible
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


mkdir ~/.pip
cat > ~/.pip/pip.conf <<EOF
[global]
index-url = http://mirrors.aliyun.com/pypi/simple/
[install]
trusted-host=mirrors.aliyun.com
EOF

pvcreate /dev/sda2
vgcreate cinder-volumes /dev/sda2
systemctl  enable lvm2-lvmetad.service

pip install kolla-ansible --ignore-installed PyYAML
yes | cp -r /usr/share/kolla-ansible/etc_examples/kolla /etc/
yes | cp /usr/share/kolla-ansible/ansible/inventory/* /etc/kolla/

# 查看密码
cat /etc/kolla/passwords.yml | grep "keystone_admin_password"

cat > /etc/kolla/globals.yml  <<EOF
---
kolla_base_distro: "centos"
kolla_install_type: "binary"
openstack_release: "stein"
kolla_internal_vip_address: "192.168.225.193"
network_interface: "enp61s0f0"
kolla_external_vip_interface: "{{ network_interface }}"
api_interface: "{{ network_interface }}"
storage_interface: "{{ network_interface }}"
cluster_interface: "{{ network_interface }}"
tunnel_interface: "{{ network_interface }}"
dns_interface: "{{ network_interface }}"
neutron_external_interface: "enp61s0f3"
enable_haproxy: "no"
enable_cinder: "yes"
enable_cinder_backend_lvm: "yes"
glance_enable_rolling_upgrade: "no"
cinder_volume_group: "cinder-volumes"
ironic_dnsmasq_dhcp_range:
tempest_image_id:
tempest_flavor_ref_id:
tempest_public_network_id:
tempest_floating_network_name:
EOF

ssh-keygen 
ssh-copy-id -i /root/.ssh/id_rsa.pub root@compute1
ssh-copy-id -i /root/.ssh/id_rsa.pub root@control11

cat > /etc/kolla/multinode <<EOF
[control]
control11 ansible_user=root ansible_password=123456 ansible_become=true
[network]
control11 ansible_user=root ansible_password=123456 ansible_become=true
[compute]
compute1 ansible_user=root ansible_password=123456 ansible_become=true
[monitoring]
control11 ansible_user=root ansible_password=123456 ansible_become=true
[storage]
control11 ansible_user=root ansible_password=123456 ansible_become=true
[deployment]
control11       ansible_connection=local
[baremetal:children]
control
network
compute
storage
monitoring
EOF

yum upgrade -y


终极手动部署方法：https://www.tracymc.cn/archives/2049
https://blog.51cto.com/11694088/2459830
https://blog.csdn.net/qq_44744215/article/details/103745762

控制节点：192.168.225.193  openstack_master
子节点：  192.168.225.194  pcre_centos7_2的克隆

机器配置：6GB内存   双网卡   200GB硬盘   CentOS7.2

openstack环境配置:
1)首先看主机是否支持虚拟化,有结果即是支持,没结果就不用看下面的了.

 grep -E '(svm|vmx)' /proc/cpuinfo
 

# 1，域名解析和关闭防火墙(全部执行)
############################################################################
cat > /etc/hosts << EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.225.193 controller      
192.168.225.194 openstack
EOF
sed -i 's#SELINUX=enforcing#SELINUX=disabled#g' /etc/sysconfig/selinux
setenforce 0
systemctl stop firewalld.service
systemctl disable firewalld.service

# 设置主机名 192.168.225.193
hostnamectl set-hostname controller
############################################################################

# 2，配置阿里拓展源
############################################################################
mkdir -p /etc/yum.repos.d/default
yes | cp -f /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/default
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
############################################################################

# 3，linux-node1.openstack安装配置 OpenStack
############################################################################
yum install -y wget
yum install -y centos-release-openstack-train
yum install -y python-openstackclient
yum upgrade -y
yum install -y openstack-selinux
##MySQL
yum install -y mariadb mariadb-server MySQL-python
##RabbitMQ
yum install -y rabbitmq-server
##Keystone
yum install -y openstack-keystone httpd mod_wsgi memcached python-memcached
##Glance
yum install -y openstack-glance python-glance python-glanceclient
##Nova
yum install -y openstack-nova-api openstack-nova-cert openstack-nova-conductor openstack-nova-console openstack-nova-novncproxy openstack-nova-scheduler python-novaclient
##Neutron linux-node1.example.com
yum install -y openstack-neutron openstack-neutron-ml2 openstack-neutron-linuxbridge python-neutronclient ebtables ipset
##Dashboard
yum install -y openstack-dashboard
##Cinder
yum install -y openstack-cinder python-cinderclient
############################################################################


# 4，linux-node2.openstack 安装配置 OpenStack
############################################################################
yum install -y wget
yum install -y http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-8.noarch.rpm
yum install centos-release-openstack-train
yum install python-openstackclient
yum upgrade -y
yum install -y openstack-selinux
##Nova linux-node2.openstack
yum install -y openstack-nova-compute sysfsutils
##Neutron linux-node2.openstack
yum install -y openstack-neutron openstack-neutron-linuxbridge ebtables ipset
##Cinder
yum install -y openstack-cinder python-cinderclient targetcli python-oslo-policy
############################################################################

# 5，控制器配置数据库
cat > /etc/my.cnf.d/openstack.cnf<<EOF
[mysqld]
bind-address = 192.168.225.193
default-storage-engine = innodb
innodb_file_per_table = on
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
EOF
systemctl start mariadb
systemctl enable mariadb

# 6,控制器安装RabbitMQ
yum -y install rabbitmq-server
systemctl start rabbitmq-server
systemctl enable rabbitmq-server

rabbitmqctl add_user openstack Aa12345678
rabbitmqctl set_permissions openstack ".*" ".*" ".*"

# 7，控制器安装memcached
yum -y install memcached python-memcached
sed -i -e '/OPTIONS=/d' /etc/sysconfig/memcached
cat >> /etc/sysconfig/memcached<<EOF
OPTIONS="-l 127.0.0.1,::1,controller,openstack"
EOF
systemctl start memcached
systemctl enable memcached

# 8，控制器安装etcd服务
yum -y install etcd
sed -i "s@localhost@10\.2\.1\.10@g" /etc/etcd/etcd.conf
cat > /etc/etcd/etcd.conf <<EOF
#[Member]
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_PEER_URLS="http://192.168.225.193:2380"
ETCD_LISTEN_CLIENT_URLS="http://192.168.225.193:2379"
ETCD_NAME="controller"
#[Clustering]
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://192.168.225.193:2380"
ETCD_ADVERTISE_CLIENT_URLS="http://192.168.225.193:2379"
ETCD_INITIAL_CLUSTER="controller=http://192.168.225.193:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster-01"
ETCD_INITIAL_CLUSTER_STATE="new"
EOF
systemctl start etcd
systemctl enable etcd

# 9，控制器keystone服务
mysql -u root -p -P 3306 -Bse "create database keystone;"
mysql -u root -p -P 3306 -Bse "grant all privileges on keystone.* to keystone@'localhost' identified by 'Aa12345678';"
mysql -u root -p -P 3306 -Bse "grant all privileges on keystone.* to keystone@'%' identified by 'Aa12345678';"
mysql -u root -p -P 3306 -Bse "flush privileges;"
yum -y install openstack-keystone httpd mod_wsgi
yum -y install httpd
yum -y install httpd-tools libapr-1.so.0 libaprutil-1.so.0 mailcap

vi /etc/keystone/keystone.conf
[database]
connection = mysql+pymysql://keystone:Aa12345678@controller/keystone
#database只修改这一行,其他不用改
[token]
provider = fernet
#token只修改这一行,其他不用改

su -s /bin/sh -c "keystone-manage db_sync" keystone
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone

keystone-manage bootstrap --bootstrap-password ADMIN_PASS \
  --bootstrap-admin-url http://controller:5000/v3/ \
  --bootstrap-internal-url http://controller:5000/v3/ \
  --bootstrap-public-url http://controller:5000/v3/ \
  --bootstrap-region-id RegionOne

vi /etc/httpd/conf/httpd.conf
ServerName controller

ln -s /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/

systemctl enable httpd
systemctl start httpd

export OS_USERNAME=admin
export OS_PASSWORD=ADMIN_PASS
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3

openstack domain create --description "An Example Domain" example
openstack project create --domain default --description "Service Project" service
openstack project create --domain default --description "Demo Project" myproject
openstack user create --domain default --password-prompt myuser
openstack role create myrole
openstack role add --project myproject --user myuser myrole
unset OS_AUTH_URL OS_PASSWORD
openstack --os-auth-url http://controller:5000/v3 --os-project-domain-name Default --os-user-domain-name Default --os-project-name admin --os-username admin token issue
openstack --os-auth-url http://controller:5000/v3 --os-project-domain-name Default --os-user-domain-name Default --os-project-name myproject --os-username myuser token issue

cat > admin-openrc <<EOF
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=ADMIN_PASS
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
EOF
. admin-openrc
openstack token issue

# 安装glance服务
mysql -u root -p -P 3306 -Bse "CREATE DATABASE glance;"
mysql -u root -p -P 3306 -Bse "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY 'Aa12345678';"
mysql -u root -p -P 3306 -Bse "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY 'Aa12345678';"
mysql -u root -p -P 3306 -Bse "flush privileges;"
. admin-openrc
openstack user create --domain default --password-prompt glance
openstack role add --project service --user glance admin
openstack service create --name glance --description "OpenStack Image" image
openstack endpoint create --region RegionOne image public http://controller:9292
openstack endpoint create --region RegionOne image internal http://controller:9292
openstack endpoint create --region RegionOne image admin http://controller:9292

yum -y install openstack-glance

vi /etc/glance/glance-api.conf
[database]行
connection = mysql+pymysql://glance:Aa12345678@controller/glance
[keystone_authtoken]
www_authenticate_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = glance
password = ADMIN_PASS
[paste_deploy]
flavor = keystone
[glance_store]
stores = file,http
default_store = file
filesystem_store_datadir = /var/lib/glance/images/

su -s /bin/sh -c "glance-manage db_sync" glance
systemctl enable openstack-glance-api
systemctl start openstack-glance-api

# 安装placement服务
mysql -u root -p -P 3306 -Bse "CREATE DATABASE placement;"
mysql -u root -p -P 3306 -Bse "GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'localhost' IDENTIFIED BY 'Aa12345678';"
mysql -u root -p -P 3306 -Bse "GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'%' IDENTIFIED BY 'Aa12345678';"
mysql -u root -p -P 3306 -Bse "flush privileges;"
. admin-openrc
openstack user create --domain default --password-prompt placement
openstack role add --project service --user placement admin
openstack service create --name placement --description "Placement API" placement
openstack endpoint create --region RegionOne placement public http://controller:8778
openstack endpoint create --region RegionOne placement internal http://controller:8778
openstack endpoint create --region RegionOne placement admin http://controller:8778
yum -y install openstack-placement-api

vi /etc/placement/placement.conf
[placement_database]
connection = mysql+pymysql://placement:Aa12345678@controller/placement
[api]
auth_strategy = keystone
[keystone_authtoken]
auth_url = http://controller:5000/v3
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = placement
password = ADMIN_PASS

su -s /bin/sh -c "placement-manage db sync" placement
systemctl restart httpd

#安装nova服务
mysql -u root -p -P 3306 -Bse "CREATE DATABASE nova_api;"
mysql -u root -p -P 3306 -Bse "CREATE DATABASE nova;"
mysql -u root -p -P 3306 -Bse "CREATE DATABASE nova_cell0;"
mysql -u root -p -P 3306 -Bse "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY 'Aa12345678';"
mysql -u root -p -P 3306 -Bse "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY 'Aa12345678';"
mysql -u root -p -P 3306 -Bse "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'Aa12345678';"
mysql -u root -p -P 3306 -Bse "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'Aa12345678';"
mysql -u root -p -P 3306 -Bse "GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' IDENTIFIED BY 'Aa12345678';"
mysql -u root -p -P 3306 -Bse "GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' IDENTIFIED BY 'Aa12345678';"
mysql -u root -p -P 3306 -Bse "flush privileges;"

. admin-openrc

openstack user create --domain default --password-prompt nova
openstack role add --project service --user nova admin
openstack service create --name nova --description "OpenStack Compute" compute
openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1
openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1

yum -y install openstack-nova-api openstack-nova-conductor openstack-nova-novncproxy openstack-nova-scheduler

vi /usr/share/nova/nova-dist.conf
[database]
connection = mysql+pymysql://nova:Aa12345678@controller/nova
connection = mysql://nova:Aa12345678@controller/nova

vi /etc/nova/nova.conf
[DEFAULT]
# ...
enabled_apis = osapi_compute,metadata
transport_url = rabbit://openstack:Aa12345678@controller
my_ip = 192.168.225.193
use_neutron = true
firewall_driver = nova.virt.firewall.NoopFirewallDriver
[api_database]
# ...
connection = mysql+pymysql://nova:Aa12345678@controller/nova_api
[database]
# ...
connection = mysql+pymysql://nova:Aa12345678@controller/nova
[api]
# ...
auth_strategy = keystone
[keystone_authtoken]
# ...
www_authenticate_uri = http://controller:5000/
auth_url = http://controller:5000/
memcached_servers = http://controller:11211/
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = nova
password = ADMIN_PASS
[vnc]
enabled = true
# ...
server_listen = $my_ip
server_proxyclient_address = $my_ip
[glance]
# ...
api_servers = http://controller:9292
[oslo_concurrency]
# ...
lock_path = /var/lib/nova/tmp
[placement]
# ...
region_name = RegionOne
project_domain_name = Default
project_name = service
auth_type = password
user_domain_name = Default
auth_url = http://controller:5000/v3
username = placement
password = ADMIN_PASS

su -s /bin/sh -c "nova-manage api_db sync" nova
su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova
su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova
su -s /bin/sh -c "nova-manage db sync" nova
su -s /bin/sh -c "nova-manage cell_v2 list_cells" nova
systemctl enable openstack-nova-api openstack-nova-scheduler openstack-nova-conductor openstack-nova-novncproxy
systemctl restart openstack-nova-api openstack-nova-scheduler openstack-nova-conductor openstack-nova-novncproxy

# 在计算节点配置nova服务
yum -y install openstack-nova-compute

cat> /etc/nova/nova.conf <<EOF
[DEFAULT]
enabled_apis = osapi_compute,metadata
transport_url = rabbit://openstack:Aa12345678@controller:5672/
my_ip = 192.168.225.194
use_neutron = true
firewall_driver = nova.virt.firewall.NoopFirewallDriver
[api]
auth_strategy = keystone
[api_database]
[barbican]
[cache]
[cinder]
[compute]
[conductor]
[console]
[consoleauth]
[cors]
[database]
[devices]
[ephemeral_storage_encryption]
[filter_scheduler]
[glance]
api_servers = http://controller:9292
[guestfs]
[healthcheck]
[hyperv]
[ironic]
[key_manager]
[keystone]
[keystone_authtoken]
www_authenticate_uri = http://controller:5000/
auth_url = http://controller:5000/
memcached_servers = controller:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = nova
password = ADMIN_PASS
[libvirt]
[metrics]
[mks]
[neutron]
[notifications]
[osapi_v21]
[oslo_concurrency]
lock_path = /var/lib/nova/tmp
[oslo_messaging_amqp]
[oslo_messaging_kafka]
[oslo_messaging_notifications]
[oslo_messaging_rabbit]
[oslo_middleware]
[oslo_policy]
[pci]
[placement]
region_name = RegionOne
project_domain_name = Default
project_name = service
auth_type = password
user_domain_name = Default
auth_url = http://controller:5000/v3
username = placement
password = ADMIN_PASS
[powervm]
[privsep]
[profiler]
[quota]
[rdp]
[remote_debug]
[scheduler]
[serial_console]
[service_user]
[spice]
[upgrade_levels]
[vault]
[vendordata_dynamic_auth]
[vmware]
[vnc]
enabled = true
server_listen = 0.0.0.0
server_proxyclient_address = $my_ip
novncproxy_base_url = http://controller:6080/vnc_auto.html
[workarounds]
[wsgi]
[xenserver]
[xvp]
[zvm]
EOF
#!!!!启动失败查看日志！！
systemctl enable libvirtd openstack-nova-compute
systemctl start libvirtd openstack-nova-compute

# 在控制节点上配置网络服务neutron
. admin-openrc
openstack compute service list --service nova-compute
su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova
mysql -u root -p -P 3306 -Bse "CREATE DATABASE neutron;"
mysql -u root -p -P 3306 -Bse "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'Aa12345678';"
mysql -u root -p -P 3306 -Bse "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'Aa12345678';"
mysql -u root -p -P 3306 -Bse "flush privileges;"
. admin-openrc
openstack user create --domain default --password-prompt neutron
openstack role add --project service --user neutron admin
openstack service create --name neutron --description "OpenStack Networking" network
openstack endpoint create --region RegionOne network public http://controller:9696
openstack endpoint create --region RegionOne network internal http://controller:9696
openstack endpoint create --region RegionOne network admin http://controller:9696

yum install openstack-neutron openstack-neutron-ml2 openstack-neutron-linuxbridge ebtables

vi /etc/neutron/neutron.conf
[database]
# ...
connection = mysql+pymysql://neutron:Aa12345678@controller/neutron
[DEFAULT]
# ...
core_plugin = ml2
service_plugins = router
allow_overlapping_ips = true
transport_url = rabbit://openstack:Aa12345678@controller
auth_strategy = keystone
notify_nova_on_port_status_changes = true
notify_nova_on_port_data_changes = true
[keystone_authtoken]
# ...
www_authenticate_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = http://controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = neutron
password = ADMIN_PASS
[nova]
# ...
auth_url = http://controller:5000
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = nova
password = ADMIN_PASS
[oslo_concurrency]
# ...
lock_path = /var/lib/neutron/tmp

vi /etc/neutron/plugins/ml2/ml2_conf.ini
[ml2]
# ...
type_drivers = flat,vlan,vxlan
tenant_network_types = vxlan
mechanism_drivers = linuxbridge,l2population
extension_drivers = port_security
[ml2_type_flat]
# ...
flat_networks = provider
[ml2_type_vxlan]
# ...
vni_ranges = 1:1000
[securitygroup]
# ...
enable_ipset = true


vi /etc/neutron/plugins/ml2/linuxbridge_agent.ini
[linux_bridge]
physical_interface_mappings = provider:ens33  #网卡名
[vxlan]
enable_vxlan = true
local_ip = 192.168.225.193
l2_population = true
[securitygroup]
enable_security_group = true
firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver


cat >> /etc/sysctl.conf <<EOF
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sysctl -p


vi /etc/neutron/l3_agent.ini
[DEFAULT]
# ...
interface_driver = linuxbridge


vi /etc/neutron/dhcp_agent.ini
[DEFAULT]
# ...
interface_driver = linuxbridge
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
enable_isolated_metadata = true

vi /etc/neutron/metadata_agent.ini
nova_metadata_host = controller
metadata_proxy_shared_secret = METADATA_SECRET

vi /etc/nova/nova.conf
[neutron]
# ...
auth_url = http://controller:5000
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = neutron
password = NEUTRON_PASS
service_metadata_proxy = true
metadata_proxy_shared_secret = METADATA_SECRET

ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini

su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron

systemctl restart openstack-nova-api.service
systemctl enable neutron-server neutron-linuxbridge-agent neutron-dhcp-agent neutron-l3-agent neutron-metadata-agent
systemctl start neutron-server 
systemctl start neutron-l3-agent 
systemctl start neutron-linuxbridge-agent 
systemctl start neutron-dhcp-agent 
systemctl start neutron-metadata-agent

# 计算节点处理实例的连接性和安全性组.
yum -y install openstack-neutron-linuxbridge ebtables ipset 

vi /etc/neutron/neutron.conf
[DEFAULT]
# ...
transport_url = rabbit://openstack:Aa12345678@controller
auth_strategy = keystone
[keystone_authtoken]
www_authenticate_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = neutron
password = NEUTRON_PASS
[oslo_concurrency]
# ...
lock_path = /var/lib/neutron/tmp

vi /etc/neutron/plugins/ml2/linuxbridge_agent.ini
[linux_bridge]
physical_interface_mappings = provider:ens33
[vxlan]
enable_vxlan = true
local_ip = 10.2.1.11
l2_population = true
[securitygroup]
# ...
enable_security_group = true
firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver

# 安装dashboard面板

vi /etc/openstack-dashboard/local_settings
OPENSTACK_HOST = "controller"
OPENSTACK_NEUTRON_NETWORK = {
    'enable_auto_allocated_network': False,
    'enable_distributed_router': False,
    'enable_fip_topology_check': True,
    'enable_ha_router': False,
    'enable_ipv6': True,
    'enable_quotas': False,
    'enable_rbac_policy': True,
    'enable_router': False,
	'enable_lb': False,
    'enable_firewall': False,
    'enable_vpn': False,
    'default_dns_nameservers': [],
    'supported_provider_types': ['*'],
    'segmentation_id_range': {},
    'extra_provider_types': {},
    'supported_vnic_types': ['*'],
    'physical_networks': [],
}
TIME_ZONE = "PRC"

WEBROOT = '/dashboard/'
OPENSTACK_KEYSTONE_URL = "http://%s:5000/v3" % OPENSTACK_HOST
OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True
OPENSTACK_API_VERSIONS = {
    "identity": 3,
    "image": 2,
    "volume": 3,
}
OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = "Default"
OPENSTACK_KEYSTONE_DEFAULT_ROLE = "user"

vi /etc/httpd/conf.d/openstack-dashboard.conf
WSGIApplicationGroup %{GLOBAL}

访问：http://192.168.225.193/dashboard/auth/login/?next=/dashboard/project/

# 7）cinder服务(块存储服务)配置

# 8）Orchestration 服务(编排服务)配置

# 9）Murano服务配置

在控制节点上安装及配置 Orchestration 服务

常见故障处理排查及使用方法
如下提到的处理方法，适用于以上三个版本的PackStack方式安装。
1.常见错误：

Testing if puppet apply is finished :192.168.20.200_controller.pp
安装过程卡在此步骤没有任何反应。
分析：网络正常情况下此过程不超过30分钟。时间过长时，需要确认关闭NetworkManger、selinux、firewalld。还可检查硬件配置，建议4核CPU+8GB内存或更高配置。还无法解决后可添加至2个网卡、2个磁盘。

2.PackStack日志信息：
PackStack安装过程中的日志在 /var/tmp/packstack/ 目录中。无法解决问题时可查看该目录下相关日志信息。

3.常见认证文件：
执行packstack --allinone安装命令后，会在执行目录下生成
keystonerc_admin 、keystonerc_demo、packstack-answers-20181025-111102.txt三个文件。可查看keystonerc_admin文件内容获取登录Dashboard的用户名和密码。安装过程的相关配置信息记录在packstack-answers-20181025-111102.txt文件中。执行OpenStack操作命令前需要执行source keystonerc_admin命令h获取管理员认证。

4.安装成功过程记录：
[root@newton ~]# packstack --allinone
systemctl disable NetworkManger 
systemctl stop NetworkManager

5.未添加域名解析报错
安装过程出现以下报错内容时，则说明域名解析存在问题，需要检查/etc/hosts文件中的域名解析是否正确。一般在Mitaka版一键安装中较常见。
ERROR : Error appeared during Puppet run: 192.168.3.87_amqp.pp
Error: Could not start Service[rabbitmq-server]: Execution of '/usr/bin/systemctl start rabbitmq-server' returned 1: Job for rabbitmq-server.service failed because the control process exited with error code. See "systemctl status rabbitmq-server.service" and "journalctl -xe" for details.
