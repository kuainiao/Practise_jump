1，安装Docker（K8s master和K8s node1执行）
yum -y update
yum install -y wget
yum install -y yum-utils device-mapper-persistent-data lvm2
cd /etc/yum.repos.d/
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum -y install docker-ce
systemctl start docker
systemctl enable docker

2，docker加速：
sudo mkdir -p /etc/docker
cat >/etc/docker/daemon.json <<EOF
{
  "registry-mirrors": ["https://ot7dvptd.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

3，拉取k8s镜像
docker pull luyanjie/kube-apiserver:v1.13.3
docker pull luyanjie/kube-controller-manager:v1.13.3
docker pull luyanjie/kube-proxy:v1.13.3
docker pull luyanjie/kube-scheduler:v1.13.3
docker pull luyanjie/coredns:1.2.6
docker pull luyanjie/etcd:3.2.24
docker pull luyanjie/pause:3.1
docker pull luyanjie/flannel:v0.11.0-amd64
docker pull hyperledger/fabric-ca:1.4
docker pull hyperledger/fabric-tools:1.4
docker pull hyperledger/fabric-ccenv:latest
docker pull hyperledger/fabric-orderer:1.4
docker pull hyperledger/fabric-peer

docker tag luyanjie/kube-apiserver:v1.13.3             k8s.gcr.io/kube-apiserver:v1.13.3         
docker tag luyanjie/kube-controller-manager:v1.13.3    k8s.gcr.io/kube-controller-manager:v1.13.3
docker tag luyanjie/kube-proxy:v1.13.3                 k8s.gcr.io/kube-proxy:v1.13.3             
docker tag luyanjie/kube-scheduler:v1.13.3             k8s.gcr.io/kube-scheduler:v1.13.3         
docker tag luyanjie/coredns:1.2.6                      k8s.gcr.io/coredns:1.2.6                  
docker tag luyanjie/etcd:3.2.24                        k8s.gcr.io/etcd:3.2.24
docker tag luyanjie/pause:3.1                          k8s.gcr.io/pause:3.1
docker tag luyanjie/flannel:v0.11.0-amd64              k8s.gcr.io/flannel:v0.11.0-amd64

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

yum list --showduplicates | grep 'kubeadm\|kubectl\|kubelet'

[root@c0 ~]# yum install -y kubernetes-cni-0.6.0 kubelet-1.13.3 kubeadm-1.13.3 kubectl-1.13.3 --disableexcludes=kubernetes
hostnamectl set-hostname master  

hostnamectl set-hostname node1

echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
echo 1 > /proc/sys/net/ipv4/ip_forward contents
swapoff -a
vi /etc/fstab
注释swap分区
# /dev/mapper/centos-swap swap                    swap    defaults        0 0

kubeadm init --kubernetes-version=v1.13.3 --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=NumCPU
[root@c0 ~]# systemctl enable kubelet
[root@c0 ~]# systemctl start kubelet

vi /var/lib/kubelet/kubeadm-flags.env
去掉cni
systemctl daemon-reload
systemctl restart kubelet

#把密钥配置加载到自己的环境变量里
export KUBECONFIG=/etc/kubernetes/admin.conf

#每次启动自动加载$HOME/.kube/config下的密钥配置文件（K8S自动行为）
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

默认 k8s 不允许往 master 节点装东西，强行设置下允许：kubectl taint nodes --all node-role.kubernetes.io/master-

kubectl get pods -n kube-system -o wide

kubeadm join 192.168.50.44:6443 --token rr3740.se29f046hyb46qdp --discovery-token-ca-cert-hash sha256:8da8af486f9594a45685e2eca7e13fd17542e8b1b1288234701a2134e61891f4

wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f  kube-flannel.yml

K8S中文文档：https://kubernetes.io/zh/docs/tasks/administer-cluster/cpu-memory-limit/
1，部署K8S集群：
#首先生成密钥：
openssl genrsa -out /etc/kubernetes/serviceaccount.key 2048
#编辑/etc/kubenetes/apiserver
#KUBE_API_ARGS="--service_account_key_file=/etc/kubernetes/serviceaccount.key"
#编辑/etc/kubernetes/controller-manager
#KUBE_CONTROLLER_MANAGER_ARGS="--service_account_private_key_file=/etc/kubernetes/serviceaccount.key"
#最后无论是哪种解决方式都需要再重启kubernetes服务：
systemctl restart etcd kube-apiserver kube-controller-manager kube-scheduler
wget http://mirror.centos.org/centos/7/os/x86_64/Packages/python-rhsm-certificates-1.19.10-1.el7_4.x86_64.rpm
rpm2cpio python-rhsm-certificates-1.19.10-1.el7_4.x86_64.rpm | cpio -iv --to-stdout ./etc/rhsm/ca/redhat-uep.pem | tee /etc/rhsm/ca/redhat-uep.pem

# 参考：https://www.linuxhub.org/?p=4599

谷歌官方k8s镜像：docker pull mirrorgooglecontainers/kube-apiserver:v1.13.3

1，查看所有POD情况：kubectl get pods --all-namespaces
2，查看某一类别的POD全部情况：kubectl get pods -n kube-system -o wide
3，查看连接的节点情况：kubectl get nodes
4，解决节点NotReady问题：vi编辑 /var/lib/kubelet/kubeadm-flags.env 文件去掉cni，重启kubectl
systemctl daemon-reload
systemctl restart kubelet
5，端口转发：echo 1 >/proc/sys/net/ipv4/ip_forward
5，查看某个POD的运行情况：kubectl describe pod tiller-deploy-86b574cb79-lrc4b  -n kube-system
6，查看某个POD的日志：kubectl logs peer0-org1-89bc7c46b-pdv64 -n org1
7，创建一个POD：kubectl apply -f  kube-flannel.yml
8，删除一个POD：kubectl delete pod mongodb-enterprise-operator-5bc67bc976-7bnq4  -n mongodb
9，进入一个POD：kubectl exec -it cli-59d46f884-p5grk bash -n org1
10,无法在master节点部署POD：kubectl taint nodes --all node-role.kubernetes.io/master-
11，进入Alpine容器：docker exec -it CONTAINER_ID sh
12，Alpine容器安装软件：apk add --update curl
13，查看k8s dns的IP：kubectl get svc -n kube-system  
14，服务文件位于/usr/lib/systemd/system/docker.service,systemctl status docker
15，连通k8s dns：kubectl get svc -n kube-system
echo 'DOCKER_OPTS="--dns=10.96.0.10 --dns-search default.svc.cluster.local --dns-search svc.cluster.local --dns-opt ndots:2 --dns-opt timeout:2 --dns-opt attempts:2"' >> /etc/default/docker
#echo 'EnvironmentFile=-/etc/default/docker' >> /etc/systemd/system/docker.service
systemctl daemon-reload
systemctl restart docker
systemctl status docker
16，重置所有POD：kubeadm reset
17，设置默认StorageClass：vi StorageClass.yaml
##############################
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: standard
provisioner: kubernetes.io/aws-ebs
parameters::wq
  type: gp2
reclaimPolicy: Retain
allowVolumeExpansion: true
mountOptions:
  - debug
volumeBindingMode: Immediate
##############################
kubectl apply -f StorageClass.yaml
kubectl patch storageclass standard -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

官方离线部署k8s高可用：https://www.kubernetes.org.cn/5904.html
官方最新K8S+Mongo搭建方案：https://www.mongodb.com/blog/post/running-mongodb-ops-manager-in-kubernetes



20,获取主机节点证书和token：
##############################
kubeadm token create
kubeadm token list
openssl x509 -pubkey -in /etc/kubernetes/ssl/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
kubeadm join 192.168.50.232:6443 --token zbjire.3hd48uvoqsswgow6 --discovery-token-ca-cert-hash sha256:19ffab101364a187c60ad3b802c52c392c11e8f5fe62ca9a13af6ec38ddf0b96
##############################

mkdir -p /opt/share
chmod 777 /opt/share
mkdir -p /opt/data
chmod 777 /opt/data
mkdir -p /data
chmod 777 /data

yum -y install nfs-utils
 
systemctl enable nfs-server.service

cat << EOF > /etc/exports
/opt/share       192.168.50.0/24(rw,no_root_squash,async,insecure)
/data            192.168.50.0/24(rw,no_root_squash,async,insecure)
EOF
 
systemctl start nfs-server.service

mount -t nfs 192.168.50.44:/opt/share /opt/share
mount -t nfs 192.168.50.44:/data /opt/data

showmount -e 192.168.50.44

mkdir -p /data/peer/org1
mkdir -p /data/peer/org2
mkdir -p /data/orderer/orgorderer1


git clone https://github.com/batizhao/fabric-on-kubernetes.git
cd fabric-on-kubernetes
wget https://nexus.hyperledger.org/content/repositories/releases/org/hyperledger/fabric/hyperledger-fabric/darwin-amd64-1.2.0/hyperledger-fabric-darwin-amd64-1.2.0.tar.gz && tar -zxvf hyperledger-fabric-darwin-amd64-1.2.0.tar.gz && rm -rf hyperledger-fabric-darwin-amd64-1.2.0.tar.gz && rm -rf config
yum -y install python3
./generateALL.sh
python3 transform/run.py
