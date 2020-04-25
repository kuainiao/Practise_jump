1，所有机器Ansible安装：

# Ansible搭建博客：https://www.cnblogs.com/gzxbkk/p/7515634.html

wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
sed -i  's/$releasever/7/g' /etc/yum.repos.d/CentOS-Base.repo
wget -P /etc/yum.repos.d/ http://mirrors.aliyun.com/repo/epel-7.repo
yum clean all
yum makecache

yum install -y ansible

# 配置免密登录
# master执行
ssh-keygen -t rsa
ssh-copy-id -i ~/.ssh/id_rsa.pub  root@192.168.225.193
ssh-copy-id -i ~/.ssh/id_rsa.pub  root@192.168.225.194
# master执行
chmod 600 /root/.ssh/authorized_keys
# 从机执行
chmod 600 /root/.ssh/authorized_keys

# 配置执行机器
cat >> /etc/ansible/hosts <<EOF
[storm_cluster]
192.168.225.193
192.168.225.194
EOF

ansible storm_cluster -m command -a 'uptime'
ansible storm_cluster -m ping
ansible storm_cluster -m command -a "ls –al /tmp/resolv.conf"
ansible storm_cluster -m copy -a "src=/etc/ansible/ansible.cfg dest=/tmp/ansible.cfg owner=root group=root mode=0644"

官方中文文档：http://ansible.com.cn/docs/intro.html
常用指令：https://blog.51cto.com/innocence/2337822
Playbook使用：https://blog.51cto.com/12980155/2384548
