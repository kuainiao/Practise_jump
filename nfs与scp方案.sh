#!/usr/bin/env bash
cat > /data/soft/scp.sh << EOF
#!/usr/bin/expect
set timeout 30
spawn scp /data/soft/jdk-8u152-linux-x64.rpm root@${job_ip_list}:/data/soft/
expect "password:"
send "NFDWpassword123\r"
interact
EOF
expect /data/soft/scp.sh


#  主机  192.168.240.113  共享目录：/data/soft
#  从机  192.168.240.112  挂载目录：/data/soft


#  主机配置nfds临时挂载
rpm -qa |grep nfs       # 检查nfs服务是否被安装
if [ $? -ne 0 ];then
yum install nfs-utils   # 安装nfs权限
sed -i -e '/${job_ip_list}/d' /etc/exports
cat >> /etc/exports << EOF
/tmp/soft ${job_ip_list}(rw,no_root_squash,async)
EOF
service nfs start
else
sed -i -e '/${job_ip_list}/d' /etc/exports
cat >> /etc/exports << EOF
/tmp/soft ${job_ip_list}(rw,no_root_squash,async)
EOF
service nfs restart
fi

#  从机临时挂载
mkdir -p /tmp/soft
mount -t nfs 192.168.240.113:/data/soft/ /tmp/soft
cp -r /tmp/soft/jdk-8u152-linux-x64.rpm /data/soft/
umount /tmp/soft

# 主机删除nfds临时挂载
sed -i -e '/${job_ip_list}/d' /etc/exports
service nfs restart

