1，安装Docker（K8s master和K8s node1执行）
yum -y update
yum install -y wget
yum install -y yum-utils device-mapper-persistent-data lvm2
cd /etc/yum.repos.d/
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum -y install docker-ce
systemctl start docker
systemctl enable docker

2，docker加速：
创建daemon.json文件
vi /etc/docker/daemon.json
在文件内容加入：
{
    "registry-mirrors": ["http://f1361db2.m.daocloud.io"]
}
重启docker
systemctl daemon-reload
systemctl restart docker
执行下面的命令
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io
重启docker服务
service docker restart

3，拉取k8s镜像
docker pull luyanjie/kube-apiserver:v1.13.3
docker pull luyanjie/kube-controller-manager:v1.13.3
docker pull luyanjie/kube-proxy:v1.13.3
docker pull luyanjie/kube-scheduler:v1.13.3
docker pull luyanjie/coredns:1.2.6
docker pull luyanjie/etcd:3.2.24
docker pull luyanjie/pause:3.1
docker pull luyanjie/flannel:v0.11.0-amd64

docker tag luyanjie/kube-apiserver:v1.13.3             k8s.gcr.io/kube-apiserver:v1.13.3         
docker tag luyanjie/kube-controller-manager:v1.13.3    k8s.gcr.io/kube-controller-manager:v1.13.3
docker tag luyanjie/kube-proxy:v1.13.3                 k8s.gcr.io/kube-proxy:v1.13.3             
docker tag luyanjie/kube-scheduler:v1.13.3             k8s.gcr.io/kube-scheduler:v1.13.3         
docker tag luyanjie/coredns:1.2.6                      k8s.gcr.io/coredns:1.2.6                  
docker tag luyanjie/etcd:3.2.24                        k8s.gcr.io/etcd:3.2.24
docker tag luyanjie/pause:3.1                          k8s.gcr.io/pause:3.1
docker tag luyanjie/flannel:v0.11.0-amd64              k8s.gcr.io/flannel:v0.11.0-amd64

4，安装k8s 1.13.3
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
[root@c0 ~]# systemctl enable kubelet
[root@c0 ~]# systemctl start kubelet

hostnamectl set-hostname master  
echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
echo 1 > /proc/sys/net/ipv4/ip_forward contents

swapoff -a

vi /etc/fstab
注释swap分区
# /dev/mapper/centos-swap swap                    swap    defaults        0 0

kubeadm init --kubernetes-version=v1.13.3 --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=NumCPU

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

默认 k8s 不允许往 master 节点装东西，强行设置下允许：
kubectl taint nodes --all node-role.kubernetes.io/master-

kubectl get pods -n kube-system -o wide

wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f  kube-flannel.yml

5，拉取istio 1.4.0镜像
docker pull grafana/grafana:6.4.3
docker pull docker.io/prom/prometheus:v2.12.0
docker pull docker.io/istio/citadel:1.4.0
docker pull docker.io/istio/proxyv2:1.4.0
docker pull docker.io/istio/pilot:1.4.0
docker pull docker.io/istio/mixer:1.4.0
docker pull docker.io/jaegertracing/all-in-one:1.14
docker pull quay.io/kiali/kiali:v1.9

6，安装istio 1.4.0
wget https://github.com/istio/istio/releases/download/1.4.0/istio-1.4.0-linux.tar.gz
tar -zxf istio-1.4.0-linux.tar.gz
cd istio-1.4.0/
mv bin/istioctl /usr/local/bin
istioctl manifest apply --set profile=demo

7，安装服务试运行
git clone https://github.com/cloudnativebooks/cloud-native-istio.git
kubectl create ns weather
kubectl label namespace weather istio-injection=enabled
kubectl get service -n weather
kubectl get pod -n weather
kubectl apply -f install/weather-gateway.yaml