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


#  ����  192.168.240.113  ����Ŀ¼��/data/soft
#  �ӻ�  192.168.240.112  ����Ŀ¼��/data/soft


#  ��������nfds��ʱ����
rpm -qa |grep nfs       # ���nfs�����Ƿ񱻰�װ
if [ $? -ne 0 ];then
yum install nfs-utils   # ��װnfsȨ��
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

#  �ӻ���ʱ����
mkdir -p /tmp/soft
mount -t nfs 192.168.240.113:/data/soft/ /tmp/soft
cp -r /tmp/soft/jdk-8u152-linux-x64.rpm /data/soft/
umount /tmp/soft

# ����ɾ��nfds��ʱ����
sed -i -e '/${job_ip_list}/d' /etc/exports
service nfs restart

