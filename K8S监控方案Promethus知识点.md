1，小米监控面板Naftis：https://zhuanlan.zhihu.com/p/47643066
2，青云监控面板kubesphere：https://fuckcloudnative.io/posts/kubesphere/
3，普罗米修斯：https://learnku.com/articles/22193

4，Kubesphere搭建文档：https://www.cnblogs.com/wangxu01/articles/11777636.html
脚本图形化监控：https://blog.csdn.net/M2l0ZgSsVc7r69eFdTj/article/details/98540150
入门：https://www.cnblogs.com/suveng/p/11511517.html

主机监控指标：https://songjiayang.gitbooks.io/prometheus/content/exporter/nodeexporter_query.html
Promethus监控docker：https://yunlzheng.gitbook.io/prometheus-book/part-ii-prometheus-jin-jie/exporter/commonly-eporter-usage/use-prometheus-monitor-container

CPU使用率：100 - (avg by (instance) (irate(node_cpu_seconds_total{job="prometheus",mode="idle"}[5m])) * 100)
内存使用率：100 - ((node_memory_MemFree_bytes{job="prometheus"}+node_memory_Cached_bytes{job="prometheus"}+node_memory_Buffers_bytes{job="prometheus"})/node_memory_MemTotal_bytes) * 100
上行带宽：sum by (job) (irate(node_network_receive_bytes_total{job="prometheus",device!~"bond.*?|lo"}[5m])/128)
下行带宽：sum by (job) (irate(node_network_transmit_bytes_total{job="prometheus",device!~"bond.*?|lo"}[5m])/128)
磁盘使用率：100 - node_filesystem_free{instance="xxx",fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs|udev|none|devpts|sysfs|debugfs|fuse.*"} / node_filesystem_size{instance="xxx",fstype!~"rootfs|selinuxfs|autofs|rpc_pipefs|tmpfs|udev|none|devpts|sysfs|debugfs|fuse.*"} * 100

容器CPU使用率：sum(irate(container_cpu_usage_seconds_total{image!=""}[1m])) without (cpu)

##################################################################################################################
wget https://github.com/prometheus/node_exporter/releases/download/v0.16.0/node_exporter-0.16.0.linux-amd64.tar.gz
wget https://github.com/prometheus/prometheus/releases/download/v2.2.1/prometheus-2.2.1.linux-amd64.tar.gz
wget https://dl.grafana.com/oss/release/grafana-6.6.2-1.x86_64.rpm

scp grafana-6.4.3-1.x86_64.rpm 

sudo useradd --no-create-home --shell /usr/sbin/nologin prometheus
sudo useradd --no-create-home --shell /bin/false node_exporter

sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus

sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus

tar -xzvf node_exporter-0.18.1.linux-amd64.tar.gz
sudo cp node_exporter-0.18.1.linux-amd64/node_exporter /usr/local/bin
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

cat >> /etc/systemd/system/node_exporter.service << EOF
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter

###################################################################


docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:rw \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  google/cadvisor:latest

###################################################################

tar -xzvf prometheus-2.10.0-rc.0.linux-amd64.tar.gz
cd prometheus-2.10.0-rc.0.linux-amd64
cp ./prometheus /usr/local/bin/
cp ./promtool /usr/local/bin/
chown prometheus:prometheus /usr/local/bin/prometheus
chown prometheus:prometheus /usr/local/bin/promtool
cp -r ./consoles /etc/prometheus
cp -r ./console_libraries /etc/prometheus
chown -R prometheus:prometheus /etc/prometheus/consoles
chown -R prometheus:prometheus /etc/prometheus/console_libraries
编辑 /etc/prometheus/prometheus.yml 
#################################
global:
  scrape_interval:     15s
  evaluation_interval: 15s

rule_files:

scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9100']
	  
    - job_name: 'cadvisor'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:8080']
#################################
chown prometheus:prometheus /etc/prometheus/prometheus.yml

sudo -u prometheus /usr/local/bin/prometheus --config.file /etc/prometheus/prometheus.yml --storage.tsdb.path /var/lib/prometheus/ --web.console.templates=/etc/prometheus/consoles --web.console.libraries=/etc/prometheus/console_libraries

cat >> /etc/systemd/system/prometheus.service << EOF
[Unit]
  Description=Prometheus Monitoring
  Wants=network-online.target
  After=network-online.target

[Service]
  User=prometheus
  Group=prometheus
  Type=simple
  ExecStart=/usr/local/bin/prometheus \
  --config.file /etc/prometheus/prometheus.yml \
  --storage.tsdb.path /var/lib/prometheus/ \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries
  ExecReload=/bin/kill -HUP $MAINPID

[Install]
  WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus

rpm -ivh grafana-6.4.3-1.x86_64.rpm
sudo systemctl daemon-reload && sudo systemctl enable grafana-server && sudo systemctl start grafana-server













# https://kubesphere.io/zh-CN/install/
设置默认StorageClass：vi StorageClass.yaml
##############################
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: standard
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
reclaimPolicy: Retain
allowVolumeExpansion: true
mountOptions:
  - debug
volumeBindingMode: Immediate
##############################
kubectl apply -f StorageClass.yaml
kubectl patch storageclass <your-class-name> -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
docker pull sapcc/tiller:v2.16.1
docker tag sapcc/tiller:v2.16.1 gcr.io/kubernetes-helm/tiller:v2.16.1
curl -L https://git.io/get_helm.sh | bash
kubectl apply -f helm-rbac.yaml
helm init --service-account=tiller --history-max 300
kubectl get deployment tiller-deploy -n kube-system
# https://devopscube.com/install-configure-helm-kubernetes/

docker pull kubesphere/ks-installer:v2.1.0
kubectl apply -f https://raw.githubusercontent.com/kubesphere/ks-installer/master/kubesphere-minimal.yaml
kubectl logs -n kubesphere-system $(kubectl get pod -n kubesphere-system -l app=ks-install -o jsonpath='{.items[0].metadata.name}') -f
kubectl get pods --all-namespaces
