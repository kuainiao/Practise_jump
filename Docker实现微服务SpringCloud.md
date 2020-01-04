SpingCloud+Docker搭建

1，安装最新版Docker
###############################################################
yum -y update
yum install -y wget
yum install -y yum-utils device-mapper-persistent-data lvm2
cd /etc/yum.repos.d/
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum -y install docker-ce
systemctl start docker
systemctl enable docker
###############################################################

2，docker加速：
###############################################################
sudo mkdir -p /etc/docker
cat >/etc/docker/daemon.json <<EOF
{
  "registry-mirrors": ["https://ot7dvptd.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
###############################################################

3，安装jdk环境
#############################################################
rpm -ivh jdk-8u202-linux-x64.rpm
pid="sed -i '/export JAVA_HOME/d' /etc/profile"
eval $pid
pid="sed -i '/export CLASSPATH/d' /etc/profile"
eval $pid
cat >> /etc/profile <<EOF
export JAVA_HOME=/usr/java/jdk1.8.0_152
export CLASSPATH=%JAVA_HOME%/lib:%JAVA_HOME%/jre/lib
export PATH=\$PATH:\$JAVA_HOME/bin
EOF
source /etc/profile
java -version
#############################################################

4，安装maven
#############################################################
wget https://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
tar -xzvf apache-maven-3.6.3-bin.tar.gz -C /usr/local
mv /usr/local/apache-maven-3.6.3/ /usr/local/maven/
cat >> /etc/profile <<EOF
MAVEN_HOME=/usr/local/maven
export MAVEN_HOME
export PATH=\$PATH:\$MAVEN_HOME/bin
EOF
source /etc/profile
#############################################################

5，拉取源码
#############################################################
yum -y install git
git clone https://github.com/xiaobingchan/springcloud_docker.git
docker pull abrtech/alpine-oraclejdk8:latest
docker tag abrtech/alpine-oraclejdk8:latest frolvlad/alpine-oraclejdk8:slim
cd springcloud_docker/eureka-server
mvn clear
mvn package docker:build
docker run -p 8761:8761 -t forezp/eureka-server

cd springcloud_docker/service-hi
mvn clear
mvn package docker:build
docker run -p 8763:8763 -t forezp/service-hi
#############################################################

6，访问：http://192.168.182.210:8761/