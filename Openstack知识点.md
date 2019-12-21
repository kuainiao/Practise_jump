


M版部署：https://github.com/xiaobingchan/mitaka

0，单机控制节点Vmware虚拟机配置：双核、4G内存、双硬盘、双网卡、开启CPU支持虚拟化；系统环境：centos7.2
1，视频资料和安装包：链接：https://pan.baidu.com/s/1P6JHQQ_IU6m5-pzS_xB5ZA 提取码：513y
2，下载安装包后：解压mitaka-resource-centos7.2-0719.tar.gz ，复制到mitaka项目的根目录
3，修改配置：mitaka\etc\hosts 和 mitaka\etc\openstack.conf ，一定要修改正确
4，若rabbitmq创建用户失败：/etc/hosts 注释 IP解释非localhost映射；

Opebstack版本：
M版16年发布
P版17年分布
Q版和R版18年发布

R版部署：
IP Address: 172.16.80.131 （固定IP，不要使用DHCP）
1，本次部署采用虚拟机的型式安装CentOS 7.6，配置4 vCPU，32G RAM，100G HDD，一个网络接口
（ens160）。开启虚拟机CPU的硬件虚拟化功能。
2，检查虚拟机支持CPU VT功能，返回值不为0表示支持。
   egrep --color 'vmx|svm' /proc/cpuinfo | wc -l
3，更新系统
   yum update -y
4，安装RDO源
   yum install -y https://rdoproject.org/repos/rdo-release.rpm
5，关闭并禁用防火墙
   systemctl disable firewalld
   systemctl stop firewalld
6，关闭并禁用NetworkManager
   systemctl disable NetworkManager
   systemctl stop NetworkManager
   systemctl enable network
   systemctl start network
7，禁用SELINUX
   setenforce 0
   sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
开始安装
1，安装Packstack Installer
yum install -y https://rdoproject.org/repos/rdo-release.rpm
yum install -y centos-release-openstack-rocky
yum update -y
yum install -y openstack-packstack
packstack --allinone
cat /root/keystonerc_admin

Q版部署：
Hostname: openstack.kclouder.local
IP Address: 172.16.80.131 （固定IP，不要使用DHCP）
1，本次部署采用虚拟机的型式安装CentOS 7.6，配置4 vCPU，32G RAM，100G HDD，一个网络接口
（ens160）。开启虚拟机CPU的硬件虚拟化功能。
2，检查虚拟机支持CPU VT功能，返回值不为0表示支持。
   egrep --color 'vmx|svm' /proc/cpuinfo | wc -l
3，更新系统
   yum update -y
4，安装RDO源
   yum install -y https://rdoproject.org/repos/rdo-release.rpm
5，关闭并禁用防火墙
   systemctl disable firewalld
   systemctl stop firewalld
6，关闭并禁用NetworkManager
   systemctl disable NetworkManager
   systemctl stop NetworkManager
   systemctl enable network
   systemctl start network
7，禁用SELINUX
   setenforce 0
   sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
开始安装
1，安装Packstack Installer
   yum install -y openstack-packstack
2，生成OpenStack应答文件，如果使用默认的选项运行Packstack安装程序将设置Demo project和其他
一些不需要的东西。
   packstack --gen-answer-file=/root/answer.txt
3，编辑应答文件，我们选择安装OpenStack时不安装Demo project。此外，还将创建一个名为“br-ex”的
OVS桥，用于通过名为“extnet”的逻辑段与实例(VM)进行外部连接。 修改配置文件以下选项：
   vi answer.txt
      CONFIG_PROVISION_DEMO=n          # 不安装DEMO
      CONFIG_KEYSTONE_ADMIN_PW=xxx     # 设置管理员密码
      CONFIG_HORIZON_SSL=y             # 启用SSL访问
      CONFIG_NEUTRON_OVS_BRIDGE_MAPPINGS=extnet:br-ex      # OVS Bridge名称
      CONFIG_NEUTRON_OVS_BRIDGE_IFACES=br-ex:ens160        # 接口名称
4，通过应答文件运行PackStack安装程序
   packstack --answer-file=/root/answer.txt
5，安装完成后，提示信息如下，包括Dashboard访问地址，这里为https://172.16.80.131/dashboard


成功案例1：Q版OpenStack自动安装

操作系统：CentOS7.5minimal（其它系统同样支持）
硬件配置：4vCPU+8G Memory+20G磁盘

1.关闭并禁用防火墙：

# systemctl stop firewalld
# systemctl disable firewalld
# systemctl stop NetworkManager
# systemctl disable NetworkManager
2.关闭selinux：

# setenforce 0
3.编辑/etc/selinux/config文件内容，将SELINUX值enforcing改为disabled：

SELINUX=disabled
4.配置yum源：

# yum install -y http://rdo.fedorapeople.org/rdo-release.rpm
5.安装packstack工具

# yum install -y openstack-packstack
6.Packstack一键安装：

# packstack --allinone
注解
无网络异常时，安装时间最多不过30分钟，如果有任务长时间执行无返回结果，需要查看相关日志查找问题。

成功案例2：N版OpenStack自动安装

操作系统：CentOS7.4minimal（其它系统同样支持）
硬件配置：4vCPU+8G Memory+20G磁盘

1.关闭并禁用防火墙：

# systemctl stop firewalld
# systemctl disable firewalld
# systemctl stop NetworkManager
# systemctl disable NetworkManager
2.关闭selinux：

# setenforce 0
3.编辑/etc/selinux/config文件内容，将SELINUX值enforcing改为disabled：

SELINUX=disabled
4.制作OpenStack-Newton网络源

cat /etc/yum.repos.d/CentOS-OpenStack-Newton.repo 
[OpenStack-Newton]
name=OpenStack-Newton
baseurl=http://vault.centos.org/7.4.1708/cloud/x86_64/openstack-newton/
gpgcheck=0
enabled=1
5.安装kvm源

yum install http://mirrors.163.com/centos/7.5.1804/virt/x86_64/kvm-common/centos-release-qemu-ev-1.0-1.el7.noarch.rpm
6.安装packstack工具

# yum install openstack-packstack
7.Packstack一键安装：

# packstack --allinone
注解
无网络异常时，安装时间最多不过30分钟，如果有任务长时间执行无返回结果，需要查看相关日志查找问题。

成功案例3：M版OpenStack自动安装

操作系统：CentOS7.5minimal（其它系统同样支持）
硬件配置：4vCPU+8G Memory+20G磁盘

1.关闭并禁用防火墙及NetworkManager：

systemctl stop firewalld
systemctl disable firewalld
systemctl stop NetworkManager
systemctl disable NetworkManager
2.关闭selinux：

setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
3.配置OpenStack-Mitaka网络源

cat /etc/yum.repos.d/CentOS-OpenStack.repo 
[OpenStack-Mitaka]
name=OpenStack-Mitaka
baseurl=http://vault.centos.org/7.2.1511/cloud/x86_64/openstack-mitaka/
enabled=1
gpgcheck=0
4.添加域名解析

echo "192.168.3.87  mitaka" >> /etc/hosts
域名解析非常重要，一定要添加。其中192.168.3.87是服务器ip地址，mitaka是主机名hostname,可根据实际内容进行替换。

5.安装packstack工具

# yum install openstack-packstack  libvirt
7.Packstack一键安装：

# packstack --allinone
注解
若出现与mariadb相关报错，可能是新装mariadb包与原有包版本冲突，卸载原有包即可。

成功案例4：P版OpenStack自动安装。

操作系统：CentOS7.2（其它系统同样支持）
硬件配置：4vCPU+8G Memory+20G磁盘

1.关闭并禁用防火墙：

# systemctl stop firewalld
# systemctl disable firewalld
# systemctl stop NetworkManager
# systemctl disable NetworkManager
2.关闭selinux：

# setenforce 0
编辑/etc/selinux/config文件内容，将SELINUX值enforcing改为disabled：

SELINUX=disabled
3.配置p版yum源

# yum install centos-release-openstack-pike.x86_64
4.禁用掉无法使用的CentOS-QEMU-EV.repo源，可直接删除该源文件。

# rm -rf /etc/yum.repos.d/CentOS-QEMU-EV.repo
5.手动配置可用的KVM源

[root@OpenStackPike ~]# cat /etc/yum.repos.d/CentOS-KVM.repo 
[CentOS-KVM]
name=CentOS-KVM
baseurl=http://mirror.centos.org/centos/7/virt/x86_64/kvm-common/
gpgcheck=0
enabled=1
6.配置kvm源或执行以下命令安装：

# rpm -ivh http://mirror.centos.org/centos/7/virt/x86_64/kvm-common/centos-release-qemu-ev-1.0-1.el7.noarch.rpm
7.配置好yum源后安装applydeltarpm包，防止自动安装时报错。

# yum install deltarpm -y
8.安装packstack工具

# yum install openstack-packstack
9.Packstack一键安装：

# packstack --allinone
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
