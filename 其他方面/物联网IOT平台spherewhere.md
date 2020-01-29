https://sitewhere.io/cn/

http://www.pianshen.com/article/298316827/

site,123

#1，安装Docker（K8s master和K8s node1执行）
yum -y update
yum install -y wget
yum install -y yum-utils device-mapper-persistent-data lvm2
cd /etc/yum.repos.d/
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum -y install docker-ce
systemctl start docker
systemctl enable docker

#2、安装Docker Compose
#下载
sudo curl -L “https://github.com/docker/compose/releases/download/1.22.0/docker-compose-(uname -s)-(uname?s)?(uname -m)” -o /usr/local/bin/docker-compose
#修改权限
sudo chmod +x /usr/local/bin/docker-compose
#测试安装成功否
docker-compose --version
docker-compose version 1.22.0, build f46880fe

#3、启用Swarm mode
docker swarm init

#4、构建
#安装gradle
cd /usr/local/
wget https://services.gradle.org/distributions/gradle-4.10.2-bin.zip
unzip gradle-4.10.2-bin.zip
vi /etc/profile
# 将如下代码追加到 profile 文件末尾：

GRADLE_HOME=/usr/local/gradle-4.10.2
export PATH={GRADLE_HOME}/bin:GRADLEH?OME/bin:{PATH}

#重载/etc/profile这个文件
source /etc/profile
#测试
gradle -version
#生成gradlew
cd /usr/local/gradle-4.10.2
gradle wrapper
ln -s gradlew /usr/bin/gradlew

#下载sitewhere
git clone https://github.com/sitewhere/sitewhere.git
cd sitewhere
git checkout --force sitewhere-
#执行Gradle构建脚本前先编辑gradle.properties，根据自己设置修改
dockerProtocol=tcp
dockerHostname=localhost (在本机所以不用ip或域名)
dockerPort=2375
dockerRepository=docker.io
registryUrl=https://index.docker.io/v1/
registryUsername=用户名
registryPassword=密码
registryEmail=邮箱


docker pull sitewhere/service-web-rest             
docker pull sitewhere/service-user-management      
docker pull sitewhere/service-tenant-management    
docker pull sitewhere/service-streaming-media      
docker pull sitewhere/service-schedule-management  
docker pull sitewhere/service-rule-processing      
docker pull sitewhere/service-outbound-connectors  
docker pull sitewhere/service-label-generation     
docker pull sitewhere/service-instance-management  
docker pull sitewhere/service-inbound-processing   
docker pull sitewhere/service-event-sources        
docker pull sitewhere/service-event-search         
docker pull sitewhere/service-event-management     
docker pull sitewhere/service-device-state         
docker pull sitewhere/service-device-registration  
docker pull sitewhere/service-device-management 
docker pull sitewhere/service-command-delivery 
docker pull sitewhere/service-batch-operations 
docker pull sitewhere/service-asset-management 

git clone https://github.com/sitewhere/sitewhere-recipes.git
#先构建启动基础服务镜像
cd /home/site1/sitewhere-recipes/docker-compose/infrastructure_default && docker-compose up
#再启用默认微服务（修改端口  8081:8080）
cd /home/site1/sitewhere-recipes/docker-compose/default && docker-compose up

#设置定时任务
crontab -e
01 * * * * root cd /home/site1/sitewhere-recipes/docker-compose/infrastructure_default && docker-compose up
01 * * * * root cd /home/site1/sitewhere-recipes/docker-compose/default && docker-compose up


