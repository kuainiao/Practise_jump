
hostnamectl set-hostname guilinface
echo "127.0.0.1   $(hostname)" >> /etc/hosts
export REGISTRY_MIRROR=https://registry.cn-hangzhou.aliyuncs.com
curl -sSL https://kuboard.cn/install-script/v1.18.x/install_kubelet.sh | sh -s 1.18.0
export MASTER_IP=192.168.0.224
export APISERVER_NAME=apiserver.guilinface
export POD_SUBNET=10.100.0.1/16
echo "${MASTER_IP}    ${APISERVER_NAME}" >> /etc/hosts
curl -sSL https://kuboard.cn/install-script/v1.18.x/init_master.sh | sh -s 1.18.0
kubectl get pod -n kube-system -o wide
docker pull calico/node:v3.13.1
docker pull calico/cni:v3.13.1
docker pull calico/pod2daemon-flexvol:v3.13.1

kubectl apply -f https://kuboard.cn/install-script/kuboard.yaml
kubectl apply -f https://addons.kuboard.cn/metrics-server/0.3.6/metrics-server.yaml
kubectl taint nodes --all node-role.kubernetes.io/master-
sudo mkdir -p /etc/docker
cat >/etc/docker/daemon.json <<EOF
{
  "registry-mirrors": ["https://ot7dvptd.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl restart kubelet
kubectl -n kube-system get secret $(kubectl -n kube-system get secret | grep kuboard-user | awk '{print $1}') -o go-template='{{.data.token}}' | base64 -d


https://kuboard.cn/
https://kubesphere.io/

参考优秀脚本：

curl -L https://kubesphere.io/download/stable/v2.1.1 > installer.tar.gz && tar -zxf installer.tar.gz && cd kubesphere-all-v2.1.1/scripts
curl -sSL https://kuboard.cn/install-script/v1.18.x/install_kubelet.sh | sh -s 1.18.0
curl -sSL https://kuboard.cn/install-script/v1.18.x/init_master.sh | sh -s 1.18.0

参考优秀脚本：

1，kubesphere
2，kuboard
3，Hyper 2.0




学习：https://www.kubernetes.org.cn/course
