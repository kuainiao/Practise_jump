


M�沿��https://github.com/xiaobingchan/mitaka

0���������ƽڵ�Vmware��������ã�˫�ˡ�4G�ڴ桢˫Ӳ�̡�˫����������CPU֧�����⻯��ϵͳ������centos7.2
1����Ƶ���ϺͰ�װ�������ӣ�https://pan.baidu.com/s/1P6JHQQ_IU6m5-pzS_xB5ZA ��ȡ�룺513y
2�����ذ�װ���󣺽�ѹmitaka-resource-centos7.2-0719.tar.gz �����Ƶ�mitaka��Ŀ�ĸ�Ŀ¼
3���޸����ã�mitaka\etc\hosts �� mitaka\etc\openstack.conf ��һ��Ҫ�޸���ȷ
4����rabbitmq�����û�ʧ�ܣ�/etc/hosts ע�� IP���ͷ�localhostӳ�䣻

Opebstack�汾��
M��16�귢��
P��17��ֲ�
Q���R��18�귢��

R�沿��
IP Address: 172.16.80.131 ���̶�IP����Ҫʹ��DHCP��
1�����β���������������ʽ��װCentOS 7.6������4 vCPU��32G RAM��100G HDD��һ������ӿ�
��ens160�������������CPU��Ӳ�����⻯���ܡ�
2����������֧��CPU VT���ܣ�����ֵ��Ϊ0��ʾ֧�֡�
   egrep --color 'vmx|svm' /proc/cpuinfo | wc -l
3������ϵͳ
   yum update -y
4����װRDOԴ
   yum install -y https://rdoproject.org/repos/rdo-release.rpm
5���رղ����÷���ǽ
   systemctl disable firewalld
   systemctl stop firewalld
6���رղ�����NetworkManager
   systemctl disable NetworkManager
   systemctl stop NetworkManager
   systemctl enable network
   systemctl start network
7������SELINUX
   setenforce 0
   sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
��ʼ��װ
1����װPackstack Installer
yum install -y https://rdoproject.org/repos/rdo-release.rpm
yum install -y centos-release-openstack-rocky
yum update -y
yum install -y openstack-packstack
packstack --allinone
cat /root/keystonerc_admin

Q�沿��
Hostname: openstack.kclouder.local
IP Address: 172.16.80.131 ���̶�IP����Ҫʹ��DHCP��
1�����β���������������ʽ��װCentOS 7.6������4 vCPU��32G RAM��100G HDD��һ������ӿ�
��ens160�������������CPU��Ӳ�����⻯���ܡ�
2����������֧��CPU VT���ܣ�����ֵ��Ϊ0��ʾ֧�֡�
   egrep --color 'vmx|svm' /proc/cpuinfo | wc -l
3������ϵͳ
   yum update -y
4����װRDOԴ
   yum install -y https://rdoproject.org/repos/rdo-release.rpm
5���رղ����÷���ǽ
   systemctl disable firewalld
   systemctl stop firewalld
6���رղ�����NetworkManager
   systemctl disable NetworkManager
   systemctl stop NetworkManager
   systemctl enable network
   systemctl start network
7������SELINUX
   setenforce 0
   sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
��ʼ��װ
1����װPackstack Installer
   yum install -y openstack-packstack
2������OpenStackӦ���ļ������ʹ��Ĭ�ϵ�ѡ������Packstack��װ��������Demo project������
һЩ����Ҫ�Ķ�����
   packstack --gen-answer-file=/root/answer.txt
3���༭Ӧ���ļ�������ѡ��װOpenStackʱ����װDemo project�����⣬��������һ����Ϊ��br-ex����
OVS�ţ�����ͨ����Ϊ��extnet�����߼�����ʵ��(VM)�����ⲿ���ӡ� �޸������ļ�����ѡ�
   vi answer.txt
      CONFIG_PROVISION_DEMO=n          # ����װDEMO
      CONFIG_KEYSTONE_ADMIN_PW=xxx     # ���ù���Ա����
      CONFIG_HORIZON_SSL=y             # ����SSL����
      CONFIG_NEUTRON_OVS_BRIDGE_MAPPINGS=extnet:br-ex      # OVS Bridge����
      CONFIG_NEUTRON_OVS_BRIDGE_IFACES=br-ex:ens160        # �ӿ�����
4��ͨ��Ӧ���ļ�����PackStack��װ����
   packstack --answer-file=/root/answer.txt
5����װ��ɺ���ʾ��Ϣ���£�����Dashboard���ʵ�ַ������Ϊhttps://172.16.80.131/dashboard


�ɹ�����1��Q��OpenStack�Զ���װ

����ϵͳ��CentOS7.5minimal������ϵͳͬ��֧�֣�
Ӳ�����ã�4vCPU+8G Memory+20G����

1.�رղ����÷���ǽ��

# systemctl stop firewalld
# systemctl disable firewalld
# systemctl stop NetworkManager
# systemctl disable NetworkManager
2.�ر�selinux��

# setenforce 0
3.�༭/etc/selinux/config�ļ����ݣ���SELINUXֵenforcing��Ϊdisabled��

SELINUX=disabled
4.����yumԴ��

# yum install -y http://rdo.fedorapeople.org/rdo-release.rpm
5.��װpackstack����

# yum install -y openstack-packstack
6.Packstackһ����װ��

# packstack --allinone
ע��
�������쳣ʱ����װʱ����಻��30���ӣ����������ʱ��ִ���޷��ؽ������Ҫ�鿴�����־�������⡣

�ɹ�����2��N��OpenStack�Զ���װ

����ϵͳ��CentOS7.4minimal������ϵͳͬ��֧�֣�
Ӳ�����ã�4vCPU+8G Memory+20G����

1.�رղ����÷���ǽ��

# systemctl stop firewalld
# systemctl disable firewalld
# systemctl stop NetworkManager
# systemctl disable NetworkManager
2.�ر�selinux��

# setenforce 0
3.�༭/etc/selinux/config�ļ����ݣ���SELINUXֵenforcing��Ϊdisabled��

SELINUX=disabled
4.����OpenStack-Newton����Դ

cat /etc/yum.repos.d/CentOS-OpenStack-Newton.repo 
[OpenStack-Newton]
name=OpenStack-Newton
baseurl=http://vault.centos.org/7.4.1708/cloud/x86_64/openstack-newton/
gpgcheck=0
enabled=1
5.��װkvmԴ

yum install http://mirrors.163.com/centos/7.5.1804/virt/x86_64/kvm-common/centos-release-qemu-ev-1.0-1.el7.noarch.rpm
6.��װpackstack����

# yum install openstack-packstack
7.Packstackһ����װ��

# packstack --allinone
ע��
�������쳣ʱ����װʱ����಻��30���ӣ����������ʱ��ִ���޷��ؽ������Ҫ�鿴�����־�������⡣

�ɹ�����3��M��OpenStack�Զ���װ

����ϵͳ��CentOS7.5minimal������ϵͳͬ��֧�֣�
Ӳ�����ã�4vCPU+8G Memory+20G����

1.�رղ����÷���ǽ��NetworkManager��

systemctl stop firewalld
systemctl disable firewalld
systemctl stop NetworkManager
systemctl disable NetworkManager
2.�ر�selinux��

setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
3.����OpenStack-Mitaka����Դ

cat /etc/yum.repos.d/CentOS-OpenStack.repo 
[OpenStack-Mitaka]
name=OpenStack-Mitaka
baseurl=http://vault.centos.org/7.2.1511/cloud/x86_64/openstack-mitaka/
enabled=1
gpgcheck=0
4.�����������

echo "192.168.3.87  mitaka" >> /etc/hosts
���������ǳ���Ҫ��һ��Ҫ��ӡ�����192.168.3.87�Ƿ�����ip��ַ��mitaka��������hostname,�ɸ���ʵ�����ݽ����滻��

5.��װpackstack����

# yum install openstack-packstack  libvirt
7.Packstackһ����װ��

# packstack --allinone
ע��
��������mariadb��ر�����������װmariadb����ԭ�а��汾��ͻ��ж��ԭ�а����ɡ�

�ɹ�����4��P��OpenStack�Զ���װ��

����ϵͳ��CentOS7.2������ϵͳͬ��֧�֣�
Ӳ�����ã�4vCPU+8G Memory+20G����

1.�رղ����÷���ǽ��

# systemctl stop firewalld
# systemctl disable firewalld
# systemctl stop NetworkManager
# systemctl disable NetworkManager
2.�ر�selinux��

# setenforce 0
�༭/etc/selinux/config�ļ����ݣ���SELINUXֵenforcing��Ϊdisabled��

SELINUX=disabled
3.����p��yumԴ

# yum install centos-release-openstack-pike.x86_64
4.���õ��޷�ʹ�õ�CentOS-QEMU-EV.repoԴ����ֱ��ɾ����Դ�ļ���

# rm -rf /etc/yum.repos.d/CentOS-QEMU-EV.repo
5.�ֶ����ÿ��õ�KVMԴ

[root@OpenStackPike ~]# cat /etc/yum.repos.d/CentOS-KVM.repo 
[CentOS-KVM]
name=CentOS-KVM
baseurl=http://mirror.centos.org/centos/7/virt/x86_64/kvm-common/
gpgcheck=0
enabled=1
6.����kvmԴ��ִ���������װ��

# rpm -ivh http://mirror.centos.org/centos/7/virt/x86_64/kvm-common/centos-release-qemu-ev-1.0-1.el7.noarch.rpm
7.���ú�yumԴ��װapplydeltarpm������ֹ�Զ���װʱ����

# yum install deltarpm -y
8.��װpackstack����

# yum install openstack-packstack
9.Packstackһ����װ��

# packstack --allinone
�������ϴ����Ų鼰ʹ�÷���
�����ᵽ�Ĵ����������������������汾��PackStack��ʽ��װ��
1.��������

Testing if puppet apply is finished :192.168.20.200_controller.pp
��װ���̿��ڴ˲���û���κη�Ӧ��
������������������´˹��̲�����30���ӡ�ʱ�����ʱ����Ҫȷ�Ϲر�NetworkManger��selinux��firewalld�����ɼ��Ӳ�����ã�����4��CPU+8GB�ڴ��������á����޷������������2��������2�����̡�

2.PackStack��־��Ϣ��
PackStack��װ�����е���־�� /var/tmp/packstack/ Ŀ¼�С��޷��������ʱ�ɲ鿴��Ŀ¼�������־��Ϣ��

3.������֤�ļ���
ִ��packstack --allinone��װ����󣬻���ִ��Ŀ¼������
keystonerc_admin ��keystonerc_demo��packstack-answers-20181025-111102.txt�����ļ����ɲ鿴keystonerc_admin�ļ����ݻ�ȡ��¼Dashboard���û��������롣��װ���̵����������Ϣ��¼��packstack-answers-20181025-111102.txt�ļ��С�ִ��OpenStack��������ǰ��Ҫִ��source keystonerc_admin����h��ȡ����Ա��֤��

4.��װ�ɹ����̼�¼��
[root@newton ~]# packstack --allinone
systemctl disable NetworkManger 
systemctl stop NetworkManager

5.δ���������������
��װ���̳������±�������ʱ����˵�����������������⣬��Ҫ���/etc/hosts�ļ��е����������Ƿ���ȷ��һ����Mitaka��һ����װ�нϳ�����
ERROR : Error appeared during Puppet run: 192.168.3.87_amqp.pp
Error: Could not start Service[rabbitmq-server]: Execution of '/usr/bin/systemctl start rabbitmq-server' returned 1: Job for rabbitmq-server.service failed because the control process exited with error code. See "systemctl status rabbitmq-server.service" and "journalctl -xe" for details.
