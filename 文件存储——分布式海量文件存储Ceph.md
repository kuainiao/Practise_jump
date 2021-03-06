参考博客1：https://www.cnblogs.com/kevingrace/p/9141432.html
参考博客2：https://www.kclouder.cn/centos-7-cephfs/
Ceph博客1：https://amito.me/2018/Ceph-RBD-Mirror-and-Remote-Backup
Ceph博客2：https://ivanzz1001.github.io/records/post/ceph/2018/08/16/ceph-find-file
S3 radosgw-admin操作：https://www.cnblogs.com/kuku0223/p/8257813.html
S3 s3cmd操作：https://blog.frognew.com/2017/02/using-s3-access-ceph-rgw.html
多地容灾情景：

# 环境：
# 管理节点：CentOS-7  50G+200G硬盘  内存、CPU随意
# OSD节点：CentOS-7  50G+200G硬盘  内存、CPU随意

节点	    Hostname	IP地址	            属性
Deploy节点	ceph-admin    192.168.225.194	    ceph-admin
OSD节点1  	ceph-node1	  192.168.225.193	    ceph-node1

# yum换上扩展源
yum install -y wget
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
sed -i  's/$releasever/7/g' /etc/yum.repos.d/CentOS-Base.repo
wget -P /etc/yum.repos.d/ http://mirrors.aliyun.com/repo/epel-7.repo
yum clean all
yum makecache
yum install -y epel-release

yum -y install python-pip
pip install --upgrade pip
yum install -y ceph-deploy

cat > /etc/yum.repos.d/local.repo << EOF
[Ceph-SRPMS]
name=Ceph SRPMS packages
baseurl=https://mirrors.aliyun.com/ceph/rpm-jewel/el7/SRPMS/
enabled=1
gpgcheck=0
type=rpm-md
[Ceph-aarch64]
name=Ceph aarch64 packages
baseurl=https://mirrors.aliyun.com/ceph/rpm-jewel/el7/aarch64/
enabled=1
gpgcheck=0
type=rpm-md
[Ceph-noarch]
name=Ceph noarch packages
baseurl=https://mirrors.aliyun.com/ceph/rpm-jewel/el7/noarch/
enabled=1
gpgcheck=0
type=rpm-md
[Ceph-x86_64]
name=Ceph x86_64 packages
baseurl=https://mirrors.aliyun.com/ceph/rpm-jewel/el7/x86_64/
enabled=1
gpgcheck=0
EOF



# rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
yum clean all
yum install -y ceph
yum install -y ceph-fuse --no-adjust-repos
yum install -y ceph-radosgw --nogpgcheck
 


# 每个节点修改
hostnamectl set-hostname ceph-admin
hostnamectl set-hostname ceph-node1
hostnamectl set-hostname ceph-node2

# 所有节点
cat >> /etc/hosts << EOF
192.168.225.194    ceph-admin
192.168.225.193    ceph-node1 
192.168.182.208    ceph-node2
EOF
systemctl stop firewalld
systemctl disable firewalld
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0


password=123456
username=cephuser
adduser -d /home/${username} -m ${username}
echo "${password}" | passwd ${username} --stdin
echo "ceph ALL = (root) NOPASSWD:AL" | sudo tee /etc/sudoers.d/ceph
chmod 0440 /etc/sudoers.d/ceph
chmod -R 775 /home/cephuser
sed -i s'/Defaults requiretty/#Defaults requiretty'/g /etc/sudoers
vi /etc/sudoers
#################################
cephuser ALL=(ALL)      NOPASSWD: ALL
#################################

# admin节点
su - cephuser
ssh-keygen -t rsa
cp /home/cephuser/.ssh/id_rsa.pub /home/cephuser/.ssh/authorized_keys
scp -r /home/cephuser/.ssh/authorized_keys ceph-node1:/home/cephuser/.ssh
scp -r /home/cephuser/.ssh/authorized_keys ceph-node2:/home/cephuser/.ssh

# OSD节点
parted -s /dev/sdb mklabel gpt mkpart primary xfs 0% 100%
mkfs.xfs /dev/sdb -f
blkid -o value -s TYPE /dev/sdb

# 所有节点验证互通
su - cephuser
ssh -p22 cephuser@ceph-admin
ssh -p22 cephuser@ceph-node1
ssh -p22 cephuser@ceph-node2

# admin节点
sudo yum  -y install ceph-deploy --no-adjust-repos
su - cephuser
mkdir cluster
cd cluster/
su -
cd /home/cephuser/cluster/
ceph-deploy new ceph-admin
cat >> ceph.conf << EOF
public network = 192.168.182.0/24
osd pool default size = 2
EOF
ceph-deploy --overwrite-conf config push  ceph-node1 ceph-node2 
ceph-deploy install ceph-admin ceph-node1 ceph-node2 --no-adjust-repos  --nogpgcheck
# 所有节点
su -
chmod -R 777 /var/lib/ceph/mon
chmod -R 777 /var/run/ceph/
chown -R ceph:ceph /var/lib/ceph/mon
chown -R ceph:ceph /var/run/ceph/
# admin节点
su - cephuser
ceph-deploy --overwrite-conf mon create-initial # 确保hostname正确
ceph-deploy gatherkeys ceph-admin
ceph-deploy disk zap ceph-node1:/dev/sdb ceph-node2:/dev/sdb
ceph-deploy osd prepare ceph-node1:/dev/sdb ceph-node2:/dev/sdb
ceph-deploy disk list ceph-node1 ceph-node2   #  激活前查看data盘符
ceph-deploy osd activate ceph-node1:/dev/sdb1 ceph-node2:/dev/sdb1 # 
ceph-deploy admin ceph-admin ceph-node1 ceph-node2
su -
chmod 644 /etc/ceph/ceph.client.admin.keyring
# admin节点
su - cephuser
ceph health
ceph -s
ceph osd stat
ceph osd tree
ceph mds stat
ceph-deploy mds create ceph-admin
ceph mds stat
ceph osd lspools
ceph osd pool create cephfs_data 10
ceph osd pool create cephfs_metadata 10 
ceph fs new myceph cephfs_metadata cephfs_data
ceph osd lspools
ceph mds stat
ceph -s

su -
mkdir /cephfs
cd /cephfs
vi /etc/ceph/ceph.conf
vi /etc/ceph/ceph.client.admin.keyring
ceph-fuse -m 192.168.225.194:6789 /cephfs

# admin节点执行
su - cephuser
ceph-deploy rgw create ceph-admin

# admin节点执行
su - cephuser
# admin节点创建完全权限用户
radosgw-admin user create --uid=zongbu --display-name="zongbu" -- tenant zongbu  --email=zongbu@example.com
radosgw-admin caps add --uid=guangzhou2 --caps="users=full_control"
# uid 指定用户id，必须要唯一
# display-name指定显示名称
# tenant 指定租户区域名称，必须要加，否则会出现桶名称重复错误，必须要唯一
# email必须要唯一
！！！记录access_key和secret_key

# 安装aws s3cmd工具
su -
wget http://nchc.dl.sourceforge.net/project/s3tools/s3cmd/1.0.0/s3cmd-1.0.0.tar.gz
tar -zxf s3cmd-1.0.0.tar.gz -C /usr/local/
mv /usr/local/s3cmd-1.0.0/ /usr/local/s3cmd/
ln -s /usr/local/s3cmd/s3cmd /usr/bin/s3cmd

常用命令：
#  radosgw-admin metadata list user          # a，列出所有用户
#  radosgw-admin bucket unlink --bucket=foo  # b，删除一个Bucket
#  radosgw-admin user info --uid=guangzhou2     # c，列出用户信息
#  s3cmd ls  #  d，列出所有桶信息
#  e，创建一个Bucket
#  s3cmd --configure
vi .s3cfg
###################
host_base = 10.92.190.168:7480
host_bucket = %(bucket)s.10.92.190.168:7480
###################
#  s3cmd mb s3://First-bucket
#  f，删除用户：radosgw-admin key rm --uid=ioszdhyw --purge-data  


1，修改RWG默认端口
##################################################
[client.rgw.node4]
rgw_frontends = "civetweb port=7481"
##################################################
ceph-deploy --overwrite-conf config push node4

2，创建用户
# admin节点执行
ceph-deploy rgw create ceph-node1

# ceph-admin节点执行
radosgw-admin user create --uid=zongbu --display-name="zongbu" -- tenant zongbu  --email=zongbu@example.com
radosgw-admin caps add --uid=zongbu --caps="users=full_control"

3，删除用户
radosgw-admin key rm --uid=ioszdhyw
radosgw-admin key rm --uid=ioszdhyw --purge-data  # 清空数据删除


4， python api 列出操作ceph 节点
import rados
cluster = rados.Rados(conffile='/etc/ceph/ceph.conf')
cluster.connect()
pools = cluster.list_pools()
for pool in pools:
	print pool

# 上传文件
import rados
cluster = rados.Rados(conffile='/etc/ceph/ceph.conf')
cluster.connect()
ioctx = cluster.open_ioctx('cephfs_data')
file_name="mysql-cluster-gpl-7.3.24-linux-glibc2.12-x86_64.tar.gz"
f=open("/root/mysql-cluster-gpl-7.3.24-linux-glibc2.12-x86_64.tar.gz","r")
file_content=f.read()
f.close()
ioctx.write_full(file_name, file_content)
ioctx.close()

# 下载文件
import rados
cluster = rados.Rados(conffile='/etc/ceph/ceph.conf')
cluster.connect()
ioctx = cluster.open_ioctx('cephfs_data')
f=open("Python-2.7.16.tgz","w")
f.write(ioctx.read("Python-2.7.16.tgz"))
f.close()
ioctx.close()

5，python api创建 S3 bucket和用户连接
import boto
import boto.s3.connection
access_key = 'E0TAR4T7WMODM97CBXM8'
secret_key = 'szc97KONbVN22BSf4iMCSih2Cy7YQlibqLXTZLSp'
conn = boto.connect_s3(
        aws_access_key_id = access_key,
        aws_secret_access_key = secret_key,	
        host = '192.168.225.193',
        port = 7480,
        is_secure=False,
        calling_format = boto.s3.connection.OrdinaryCallingFormat(),
        )
print 'List all buckets:'
buckets = conn.get_all_buckets()
for bucket in buckets:
    print bucket.name
# 创建Bucket
bucket = conn.create_bucket('bucketname') 
print bucket


代码测试
import boto
import boto.s3.connection
access_key = 'NJU812SJLNDCFD9WNO64'
secret_key = 'iYOEMsjOu1CbzfkQuf3uiIasWKSdPkSTTOy506gX'

conn = boto.connect_s3(
        aws_access_key_id = access_key,
        aws_secret_access_key = secret_key,	
        host = '10.92.190.168',
        port = 7480,
        is_secure=False,
        calling_format = boto.s3.connection.OrdinaryCallingFormat(),
        )
bucket = conn.create_bucket('bucketname') 
print bucket

print 'List all buckets:'
buckets = conn.get_all_buckets()
for bucket in buckets:
print bucket.name
# 创建Bucket
bucket = conn.create_bucket('bucketname') 
print bucket

radosgw-admin user create --uid=guangzhou2 --display-name="guangzhou2" -- tenant guangzhou2  --email=guangzhou2@example.comradosgw-admin caps add --uid=guangzhou2 --caps="users=full_control"
radosgw-admin caps add --uid=guangzhou2 --caps="users=full_control"

10.92.190.168	"root
nfdw/Dx123456@Dx"	hy6Vn115GLuw


#  radosgw-admin metadata list user  #  列出ceph s3 用户
#  

radosgw-admin user rm --uid=ioszdhyw  --purge-data
radosgw-admin user rm --uid=zongbu
radosgw-admin user rm --uid=shuangtiao
radosgw-admin user rm --uid=guangzhou  --purge-data
radosgw-admin user rm --uid=admin


bucket = conn.get_bucket('First-bucket2') 

for file_key in bucket.list(): 
    print file_key.name 

