systemctl stop firewalld.service
setenforce 0
cat /etc/centos-release
uname -r
yum install qemu-kvm qemu-kvm-tools virt-manager libvirt virt-install -y
egrep '(vmx|svm)' /proc/cpuinfo
lsmod | grep kvm
systemctl start libvirtd.service
mkdir -p /kvmdir
qemu-img create -f raw /kvmdir/centos702.raw 10G
chmod -R 777 /root/
virt-install --name centos702 --virt-type kvm --ram 1024 --cdrom=/root/CentOS-7-x86_64-Minimal-1511.iso --disk path=/kvmdir/centos701.raw --network network=default --graphics vnc,listen=0.0.0.0 --noautoconsole
virsh list --all
virsh start centos701
virsh console 3
virsh shutdown centos701  #  

# KVM≥£º˚π ’œ≈≈≤È£∫ https://blog.51cto.com/13475644/2365470