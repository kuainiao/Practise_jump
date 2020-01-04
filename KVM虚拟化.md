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

# KVM常见故障排查： https://blog.51cto.com/13475644/2365470

# Ubuntu KVM装安卓：
sudo apt-get update
sudo apt-get install qemu qemu-kvm libvirt-bin
mkdir -p /kvmdir
qemu-img create -f qcow2 /kvmdir/android.img 15G
qemu-system-x86_64 -m 3048 -boot d -enable-kvm -smp 3 -net nic -net user -hda android.img -cdrom /home/mhsabbagh/android-x86_64-8.1-r1.iso
