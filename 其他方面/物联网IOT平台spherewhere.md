https://sitewhere.io/cn/

http://www.pianshen.com/article/298316827/

site,123

#1����װDocker��K8s master��K8s node1ִ�У�
yum -y update
yum install -y wget
yum install -y yum-utils device-mapper-persistent-data lvm2
cd /etc/yum.repos.d/
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum -y install docker-ce
systemctl start docker
systemctl enable docker

#2����װDocker Compose
#����
sudo curl -L ��https://github.com/docker/compose/releases/download/1.22.0/docker-compose-(uname -s)-(uname?s)?(uname -m)�� -o /usr/local/bin/docker-compose
#�޸�Ȩ��
sudo chmod +x /usr/local/bin/docker-compose
#���԰�װ�ɹ���
docker-compose --version
docker-compose version 1.22.0, build f46880fe

#3������Swarm mode
docker swarm init

#4������
#��װgradle
cd /usr/local/
wget https://services.gradle.org/distributions/gradle-4.10.2-bin.zip
unzip gradle-4.10.2-bin.zip
vi /etc/profile
# �����´���׷�ӵ� profile �ļ�ĩβ��

GRADLE_HOME=/usr/local/gradle-4.10.2
export PATH={GRADLE_HOME}/bin:GRADLEH?OME/bin:{PATH}

#����/etc/profile����ļ�
source /etc/profile
#����
gradle -version
#����gradlew
cd /usr/local/gradle-4.10.2
gradle wrapper
ln -s gradlew /usr/bin/gradlew

#����sitewhere
git clone https://github.com/sitewhere/sitewhere.git
cd sitewhere
git checkout --force sitewhere-
#ִ��Gradle�����ű�ǰ�ȱ༭gradle.properties�������Լ������޸�
dockerProtocol=tcp
dockerHostname=localhost (�ڱ������Բ���ip������)
dockerPort=2375
dockerRepository=docker.io
registryUrl=https://index.docker.io/v1/
registryUsername=�û���
registryPassword=����
registryEmail=����


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
#�ȹ�����������������
cd /home/site1/sitewhere-recipes/docker-compose/infrastructure_default && docker-compose up
#������Ĭ��΢�����޸Ķ˿�  8081:8080��
cd /home/site1/sitewhere-recipes/docker-compose/default && docker-compose up

#���ö�ʱ����
crontab -e
01 * * * * root cd /home/site1/sitewhere-recipes/docker-compose/infrastructure_default && docker-compose up
01 * * * * root cd /home/site1/sitewhere-recipes/docker-compose/default && docker-compose up


