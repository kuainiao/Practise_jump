参考1：https://www.jianshu.com/p/3868e0f75ec0
参考2：https://kubesphere.com.cn/docs/v2.1/zh-CN/installation/multi-node/#%E7%AC%AC%E4%B8%89%E6%AD%A5-%E5%AE%89%E8%A3%85-kubesphere
常见问题解决：https://www.bookstack.cn/read/kubesphere-v2.0-zh/faq-faq-install.md?wd=%E5%AF%86%E9%9B%86
nohup wget https://kubesphere.io/download/offline/advanced-2.0.2 &

master：ssh root@192.168.50.56
node1:  ssh root@192.168.50.84

# 1，保持网络连接：
crontab -l >/tmp/crontab.bak
echo "10 * * * * /etc/init.d/network restart" >> /tmp/crontab.bak
crontab /tmp/crontab.bak

# 2，ntp时间同步：
yum install -y ntpdate
yes | cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ntpdate us.pool.ntp.org
crontab -l >>/tmp/crontab.bak
echo "10 * * * * /usr/sbin/ntpdate us.pool.ntp.org | logger -t NTP" >> /tmp/crontab.bak
crontab /tmp/crontab.bak
date

# 3，安装基础软件：
yum install -y wget net-tools

# 4，安装阿里源：
# yum源换阿里源
mkdir -p /etc/yum.repos.d/default
cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/default
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
sed -i  's/$releasever/7/g' /etc/yum.repos.d/CentOS-Base.repo
yum clean all
yum makecache
# yum换上扩展源
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
sed -i  's/$releasever/7/g' /etc/yum.repos.d/CentOS-Base.repo
wget -P /etc/yum.repos.d/ http://mirrors.aliyun.com/repo/epel-7.repo
yum clean all
yum makecache
yum install -y epel-release

# 5，系统更新：
yum update -y 

# 6，关闭防火墙
setenforce 0
vi /etc/selinux/config
SELINUX=disabled
#SELINUXTYPE=targeted

systemctl stop firewalld
systemctl disable firewalld

# 7，配置ssh免密登陆：
ssh-keygen -t rsa
ssh-copy-id -i ~/.ssh/id_rsa.pub  root@192.168.50.84
ssh-copy-id -i ~/.ssh/id_rsa.pub  root@192.168.50.84
chmod 600 /root/.ssh/authorized_keys
chmod 700 /home/luyanjie

8 , 安装最新版Docker
#################################################
yum -y update
yum install -y yum-utils device-mapper-persistent-data lvm2
cd /etc/yum.repos.d/
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum -y install docker-ce
systemctl start docker
systemctl enable docker
#################################################

9，安装pip
wget --no-check-certificat  https://pypi.python.org/packages/source/s/setuptools/setuptools-2.0.tar.gz
tar zxf setuptools-2.0.tar.gz
cd setuptools-2.0
python setup.py install
cd  ..
wget https://files.pythonhosted.org/packages/00/9e/4c83a0950d8bdec0b4ca72afd2f9cea92d08eb7c1a768363f2ea458d08b4/pip-19.2.3.tar.gz --no-check-certificate
tar -xzvf pip-19.2.3.tar.gz
cd pip-19.2.3
python setup.py install
python -m pip install --upgrade pip
################################

简易安装pip工具：yum install python-pip 或 curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
python get-pip.py
pip install --upgrade pip

豆瓣pip 安装加速：pip install -i http://pypi.douban.com/simple --trusted-host pypi.douban.com packagename

永久更换pip源：修改~/.pip/pip.conf文件，如果没有就创建一个，写入如下内容（以清华源为例）：
mkdir -p ~/.pip/
cat >> ~/.pip/pip.conf <<EOF
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
[install]
EOF

######################################################################################




终极部属计划：https://aijishu.com/a/1060000000078347
https://www.qikqiak.com/post/install-kubesphere-on-k8s/
存储：https://www.cnblogs.com/wangxu01/articles/11671110.html
https://www.cnblogs.com/wangxu01/articles/11777636.html
创建nfs和pvc：https://segmentfault.com/a/1190000014453291

# 8 , 
curl -L https://kubesphere.io/download/stable/advanced-2.0.2 > advanced-2.0.2.tar.gz && tar -zxf advanced-2.0.2.tar.gz && cd kubesphere-all-advanced-2.0.2/conf


######################################################################################


# 9，
hostnamectl set-hostname master
hostnamectl set-hostname node1
hostnamectl set-hostname node2

# 1 , 安装最新版Docker
#################################################
yum -y update
yum install -y yum-utils device-mapper-persistent-data lvm2
cd /etc/yum.repos.d/
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum -y install docker-ce
systemctl start docker
systemctl enable docker
#################################################

# 2，Docker访问加速，这是阿里云加速器，详见参考：https://www.jianshu.com/p/a024dc5ade92
#################################################
sudo mkdir -p /etc/docker
cat >/etc/docker/daemon.json <<EOF
{
  "registry-mirrors": ["https://ot7dvptd.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
#################################################

docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:v1.13.5               
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:v1.13.5
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.13.5             
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:v1.13.5         
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.3.1                  
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.3.10                    
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1                      
docker pull quay-mirror.qiniu.com/coreos/flannel:v0.11.0-amd64                                 

docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:v1.13.5             k8s.gcr.io/kube-apiserver:v1.13.5                  
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:v1.13.5    k8s.gcr.io/kube-controller-manager:v1.13.5
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.13.5                 k8s.gcr.io/kube-proxy:v1.13.5             
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:v1.13.5             k8s.gcr.io/kube-scheduler:v1.13.5         
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.3.1                      k8s.gcr.io/coredns:1.3.1                  
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.3.10                        k8s.gcr.io/etcd:3.3.10
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1                          k8s.gcr.io/pause:3.1
docker tag quay-mirror.qiniu.com/coreos/flannel:v0.11.0-amd64                                     k8s.gcr.io/flannel:v0.11.0-amd64
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:v1.13.5          
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:v1.13.5 
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.13.5              
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:v1.13.5          
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.3.1                   
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.3.10                     
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1                       
docker rmi quay-mirror.qiniu.com/coreos/flannel:v0.11.0-amd64

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
EOF
yum install -y kubernetes-cni-0.6.0 kubelet-1.13.5 kubeadm-1.13.5 kubectl-1.13.5 --disableexcludes=kubernetes --nogpgcheck

echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
echo 1 > /proc/sys/net/ipv4/ip_forward contents
swapoff -a
sed  -i  '/swap/d'  /etc/fstab
kubeadm init --kubernetes-version=v1.13.5 --pod-network-cidr=10.96.0.10/24 --ignore-preflight-errors=NumCPU
systemctl enable kubelet
systemctl start kubelet
cat > /var/lib/kubelet/kubeadm-flags.env << EOF
KUBELET_KUBEADM_ARGS=--cgroup-driver=cgroupfs --pod-infra-container-image=k8s.gcr.io/pause:3.1
EOF
systemctl daemon-reload
systemctl restart kubelet
#把密钥配置加载到自己的环境变量里
export KUBECONFIG=/etc/kubernetes/admin.conf
#每次启动自动加载$HOME/.kube/config下的密钥配置文件（K8S自动行为）
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
#默认 k8s 不允许往 master 节点装东西，强行设置下允许：
kubectl taint nodes --all node-role.kubernetes.io/master-
wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f  kube-flannel.yml

#master给k8s-node添加角色
kubectl label nodes master node-role.kubernetes.io/node=

echo 1 >/proc/sys/net/ipv4/ip_forward

kubectl create deployment nginx --image=nginx:latest
kubectl expose deployment nginx --port=80 --type=NodePort

wget https://storage.googleapis.com/kubernetes-helm/helm-v2.12.3-linux-amd64.tar.gz --no-check-certificate
tar -xf helm-v2.12.3-linux-amd64.tar.gz
cd linux-amd64/
cp helm /usr/bin/

cat > tiller_rbac.yaml << EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system
EOF

kubectl apply -f tiller_rbac.yaml
kubectl get sa -n kube-system |grep tiller
helm init  --service-account tiller  --upgrade -i registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.12.3 --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts
kubectl get pod -n kube-system |grep tiller
helm version

##############################
kubeadm token create
kubeadm token list
openssl x509 -pubkey -in /etc/kubernetes/ssl/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
kubeadm join 192.168.50.229:6443 --token 8nv63j.0asxcmn9humat8dp --discovery-token-ca-cert-hash sha256:9ff4f292eac38eeca47bf4bd75540f364b338bc426f59139d754d3a1490ca326
##############################

# 每个节点
yum -y install nfs-server nfs-utils rpcbind

# 选 master 提供服务
systemctl enable nfs rpcbind
systemctl start nfs rpcbind

# 其他节点开启 
systemctl enable rpcbind
systemctl start rpcbind

# master 配置 nfs
mkdir -p /nfs/space
cat >>  /etc/exports << EOF
/nfs/space    * (rw,sync,no_root_squash)
EOF
# master 重启服务，使配置生效
systemctl restart nfs

# node1 检验
showmount -e localhost
/nfs/space 192.168.50.0/24

# nodex 检验
mount -t nfs 192.168.50.56:/nfs/space /mnt

cat > redis_pv.yaml << EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: redis-pvc
  namespace: kubesphere-system
spec:
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteMany
  nfs:
    server: 192.168.50.31
    path: "/nfs/space"
EOF
kubectl apply -f redis_pv.yaml

cat > redis_pvc.yaml << EOF
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: redis-pvc
  namespace: kubesphere-system
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 2Gi
EOF
kubectl apply -f redis_pvc.yaml



cat > storageclass.yaml << EOF
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: local
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
EOF
kubectl apply -f storageclass.yaml
  


cat <<EOF | kubectl create -f -
---
apiVersion: v1
kind: Namespace
metadata:
    name: kubesphere-system
---
apiVersion: v1
kind: Namespace
metadata:
    name: kubesphere-monitoring-system
EOF

kubectl -n kubesphere-system create secret generic kubesphere-ca  \
--from-file=ca.crt=/etc/kubernetes/pki/ca.crt  \
--from-file=ca.key=/etc/kubernetes/pki/ca.key

kubectl -n kubesphere-monitoring-system create secret generic kube-etcd-client-certs  \
--from-file=etcd-client-ca.crt=/etc/kubernetes/pki/etcd/ca.crt  \
--from-file=etcd-client.crt=/etc/kubernetes/pki/etcd/healthcheck-client.crt  \
--from-file=etcd-client.key=/etc/kubernetes/pki/etcd/healthcheck-client.key

wget https://raw.githubusercontent.com/kubesphere/ks-installer/master/kubesphere-minimal.yaml
kubectl apply -f https://raw.githubusercontent.com/kubesphere/ks-installer/master/kubesphere-minimal.yaml

`



附录：
---
apiVersion: v1
kind: Namespace
metadata:
  name: kubesphere-system

---
apiVersion: v1
data:
  ks-config.yaml: |
    ---

    persistence:
      storageClass: "kubesphere-data"

    etcd:
      monitoring: True
      endpointIps: 192.168.50.31
      port: 2379
      tlsEnable: True

    common:
      mysqlVolumeSize: 20Gi
      minioVolumeSize: 20Gi
      etcdVolumeSize: 20Gi
      openldapVolumeSize: 2Gi
      redisVolumSize: 2Gi

    metrics-server:
      enabled: False

    console:
      enableMultiLogin: True  # enable/disable multi login
      port: 30880

    monitoring:
      prometheusReplicas: 1
      prometheusMemoryRequest: 400Mi
      prometheusVolumeSize: 20Gi
      grafana:
        enabled: True

    logging:
      enabled: True
      elasticsearchMasterReplicas: 1
      elasticsearchDataReplicas: 1
      logsidecarReplicas: 2
      elasticsearchVolumeSize: 20Gi
      logMaxAge: 7
      elkPrefix: logstash
      containersLogMountedPath: ""
      kibana:
        enabled: True

    openpitrix:
      enabled: False

    devops:
      enabled: False
      jenkinsMemoryLim: 2Gi
      jenkinsMemoryReq: 1500Mi
      jenkinsVolumeSize: 8Gi
      jenkinsJavaOpts_Xms: 512m
      jenkinsJavaOpts_Xmx: 512m
      jenkinsJavaOpts_MaxRAM: 2g
      sonarqube:
        enabled: False

    servicemesh:
      enabled: False

    notification:
      enabled: True

    alerting:
      enabled: True

    harbor:
      enabled: False
      domain: harbor.devops.kubesphere.local
    gitlab:
      enabled: False
      domain: devops.kubesphere.local

kind: ConfigMap
metadata:
  name: ks-installer
  namespace: kubesphere-system

---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ks-installer
  namespace: kubesphere-system

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  creationTimestamp: null
  name: ks-installer
rules:
- apiGroups:
  - ""
  resources:
  - '*'
  verbs:
  - '*'
- apiGroups:
  - apps
  resources:
  - '*'
  verbs:
  - '*'
- apiGroups:
  - extensions
  resources:
  - '*'
  verbs:
  - '*'
- apiGroups:
  - batch
  resources:
  - '*'
  verbs:
  - '*'
- apiGroups:
  - rbac.authorization.k8s.io
  resources:
  - '*'
  verbs:
  - '*'
- apiGroups:
  - apiregistration.k8s.io
  resources:
  - '*'
  verbs:
  - '*'
- apiGroups:
  - apiextensions.k8s.io
  resources:
  - '*'
  verbs:
  - '*'
- apiGroups:
  - tenant.kubesphere.io
  resources:
  - '*'
  verbs:
  - '*'
- apiGroups:
  - certificates.k8s.io
  resources:
  - '*'
  verbs:
  - '*'
- apiGroups:
  - devops.kubesphere.io
  resources:
  - '*'
  verbs:
  - '*'
- apiGroups:
  - monitoring.coreos.com
  resources:
  - '*'
  verbs:
  - '*'
- apiGroups:
  - logging.kubesphere.io
  resources:
  - '*'
  verbs:
  - '*'
- apiGroups:
  - jaegertracing.io
  resources:
  - '*'
  verbs:
  - '*'
- apiGroups:
  - storage.k8s.io
  resources:
  - '*'
  verbs:
  - '*'
- apiGroups:
  - admissionregistration.k8s.io
  resources:
  - '*'
  verbs:
  - '*'

---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: ks-installer
subjects:
- kind: ServiceAccount
  name: ks-installer
  namespace: kubesphere-system
roleRef:
  kind: ClusterRole
  name: ks-installer
  apiGroup: rbac.authorization.k8s.io

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ks-installer
  namespace: kubesphere-system
  labels:
    app: ks-install
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ks-install
  template:
    metadata:
      labels:
        app: ks-install
    spec:
      serviceAccountName: ks-installer
      containers:
      - name: installer
        image: kubesphere/ks-installer:v2.1.0
        imagePullPolicy: "Always"
