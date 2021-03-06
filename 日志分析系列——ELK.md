# https://blog.51cto.com/andyxu/2124697
# https://blog.csdn.net/boling_cavalry/article/details/79836171

时间修正：
#######################
yum install -y ntpdate
yes | cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ntpdate us.pool.ntp.org
crontab -l >/tmp/crontab.bak
echo "*/10 * * * * /usr/sbin/ntpdate us.pool.ntp.org | logger -t NTP" >> /tmp/crontab.bak
crontab /tmp/crontab.bak
#######################

wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.7.2.tar.gz
wget https://artifacts.elastic.co/downloads/kibana/kibana-6.7.2-linux-x86_64.tar.gz
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.7.2-linux-x86_64.tar.gz
wget https://artifacts.elastic.co/downloads/logstash/logstash-6.7.2.tar.gz

tar -xzvf elasticsearch-6.7.2.tar.gz -C  /usr/local/
tar -xzvf kibana-6.7.2-linux-x86_64.tar.gz -C  /usr/local/
tar -xzvf filebeat-6.7.2-linux-x86_64.tar.gz -C  /usr/local/
tar -xzvf logstash-6.7.2.tar.gz -C  /usr/local/

首先安装jdk环境
#############################################################
wget https://repo.huaweicloud.com/java/jdk/8u202-b08/jdk-8u202-linux-x64.tar.gz
mkdir -p /usr/java/
tar -xzvf jdk-8u202-linux-x64.tar.gz -C/usr/java/
pid="sed -i '/export JAVA_HOME/d' /etc/profile"
eval $pid
pid="sed -i '/export CLASSPATH/d' /etc/profile"
eval $pid
cat >> /etc/profile <<EOF
export JAVA_HOME=/usr/java/jdk1.8.0_202
export CLASSPATH=%JAVA_HOME%/lib:%JAVA_HOME%/jre/lib
export PATH=\$PATH:\$JAVA_HOME/bin
EOF
source /etc/profile
java -version
#############################################################

groupadd elasticsearch
useradd elasticsearch -g elasticsearch
chown -R elasticsearch.elasticsearch /usr/local/elasticsearch-6.7.2
hostnamectl set-hostname elk-server
systemctl stop firewalld.service
systemctl disable firewalld.service
cat >> /etc/security/limits.conf << EOF
* soft nofile 65536
* hard nofile 131072
* soft nproc 2048
* hard nproc 4096
EOF
cat >> /etc/sysctl.conf << EOF
vm.max_map_count=655360 
EOF
sysctl -p

su - elasticsearch
/usr/local/elasticsearch-6.7.2/bin/elasticsearch -d
curl 127.0.0.1:9200

vi /usr/local/logstash-6.7.2/config/logstash.yml
#################################################
path.data: /data/logstash/data
path.logs: /data/logstash/logs
#################################################

vi /usr/local/logstash-6.7.2/default.conf
#################################################
input {
  beats {
    host => "192.168.244.200"
    port => 5044
    codec => plain {
          charset => "UTF-8"
    }
  }
}

output {
  elasticsearch {
    hosts => "127.0.0.1:9200"
    manage_template => false
    index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
    document_type => "%{[@metadata][type]}"
  }
}
##########################################

vi /usr/local/logstash-6.7.2/config/jvm.options       # 修改jvm内存 
vi /usr/local/elasticsearch-6.7.2/config/jvm.options  # 修改jvm内存 
nohup /usr/local/logstash-6.7.2/bin/logstash -f /usr/local/logstash-6.7.2/default.conf --config.reload.automatic > logstash.log &
vi /usr/local/kibana-6.7.2-linux-x86_64/config/kibana.yml
############################################
server.port: 5601
server.host: "192.168.2.207"
elasticsearch.url: "http://localhost:9200"
############################################

nohup /usr/local/kibana-6.7.2-linux-x86_64/bin/kibana > kibana.log &

vi /usr/local/filebeat-6.7.2-linux-x86_64/filebeat.yml
############################################
filebeat.prospectors:
- type: log
  enabled: true
  paths:
    - /var/log/*.log
output.logstash:
  hosts: ["localhost:5044"]
############################################
nohup /usr/local/filebeat-6.7.2-linux-x86_64/filebeat -e -c /usr/local/filebeat-6.7.2-linux-x86_64/filebeat.yml -d "publish" > filebeat.log &

1，一般没出日志都是filebeat没配置好logstash，或是elsasearch、logstash状态有问题，或是配置文件错误导致
2，一般日志找不到有可能是时间戳无法分隔的问题
3，Docker目录位置：- /var/new_lib/docker/containers/*/*-json.log
4，服务器时间与真实时间不一致


