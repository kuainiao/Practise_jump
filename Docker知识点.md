https://www.jianshu.com/p/a024dc5ade92
http://blog.chinaunix.net/uid-26168435-id-5736568.html

1，安装Docker（K8s master和K8s node1执行）
yum -y update
yum install -y wget
yum install -y yum-utils device-mapper-persistent-data lvm2
cd /etc/yum.repos.d/
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
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

3，
curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version

docker-compose up

查询Docker状态：docker info

1，查看所有docker镜像
docker images

2，拉取docker镜像
docker pull centos

3，查询docker镜像
docekr search centos

4，查看"正在运行的"docker容器
docker ps

5，创建镜像容器，启动并进入
docker run -t -i centos:latest /bin/bash

6，提交现成镜像
docker commit -m "Added json gem" -a "Docker Newbee" f1efdad2a1aa luyanjie/test:v1

7，创建Dockerfile建造镜像（docker.io/luyanjie/test）
cat >> Dockerfile << EOF
FROM ubuntu:latest
MAINTAINER Docker Newbee <luyanjie@docker.com>
RUN apt-get update -y
EOF
docker build -t="luyanjie/test:v2" .

8，精简docker容器：
cat > Dockerfile << EOF
FROM ubuntu:latest
ENV VER     3.0.0  
ENV TARBALL http://download.redis.io/releases/redis-$VER.tar.gz
RUN echo "==> Install curl and helper tools..."  && \  
    apt-get update                      && \
    apt-get install -y  curl make gcc   && \
    \
    echo "==> Download, compile, and install..."  && \
    curl -L $TARBALL | tar zxv  && \
    cd redis-$VER               && \
    make                        && \
    make install                && \
    echo "==> Clean up..."  && \
    apt-get remove -y --auto-remove curl make gcc  && \
    apt-get clean                                  && \
    rm -rf /var/lib/apt/lists/*  /redis-$VER
CMD ["redis-server"]
EOF
docker build -t="luyanjie/test:v3" .

9，限制docker容器资源：
查看容器使用情况：docker stats
限制CPU：--cpus=2 
指定CPU：--cpuset-cpus="1,3"
限制内存：-m 300M 

10，docker加速：
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



10，上传Docker镜像：
docker login  # 登陆Docker Hub
docekr logout # 登出
docker tag luyanjie/test docker.io/luyanjie/testmmyytetr22 # 打上自己的标签
docker push docker.io/luyanjie/testmmyytetr # 提交到自己的docker hub

11，升级Docker
rpm -qa | grep docker
yum remove -y docker-client-1.13.1-63.git94f4240.el7.centos.x86_64
yum remove -y docker-common-1.13.1-63.git94f4240.el7.centos.x86_64
yum remove -y docker-1.13.1-63.git94f4240.el7.centos.x86_64
curl -fsSL https://get.docker.com/ | sh
systemctl restart docker
systemctl enable docker
docker -v

12，镜像（原本）导出
docker save -o 镜像名.tar 镜像名ID
13，镜像（原本）导入
docker load -i 镜像名.tar
14，镜像（有备份变更）导出
docker export -o 容器名.tar 容器名ID
15，镜像（有备份变更）导入
docker import 容器名.tar 镜像名称:tag名称

16，简化alpine常用镜像：
docker pull smebberson/alpine-nginx
docker pull sickp/alpine-redis

17，初次进入容器（-d 表示在后台运行容器，-it交互式运行）：
一般Linux：docker run --name ubuntu_me -dit ubuntu /bin/bash
登陆alpine：docker run -dit 镜像名 sh

18，重新进入容器：
登陆alpine：docker exec -it CONTAINER_ID sh
一般Linux：docker exec -it CONTAINER_ID /bin/bash

19，指定容器名称：
docker run --name bob_the_container -i -t ubuntu /bin/bash  

20，指定容器开放端口：
docker pull nginx
docker run -p 8888:80  --name=nginx -i -t 540a289bab6c

21，目录映射：
docker run -p 8888:80 -p 8881:81 --name=nginx -i -t -v /home/test/nginx/html:/usr/share/nginx/html 540a289bab6c 

22，运行中的容器添加端口映射：
docker inspect `nginx` | grep IPAddress  #  获取容器IP地址
iptables -t nat -A  DOCKER -p tcp --dport 8002 -j DNAT --to-destination 172.17.0.4:80

23，删除存在端口规则
iptables -t nat -vnL DOCKER --line-number
iptables -t nat -D DOCKER 3

docker inspect `nginx` | grep IPAddress  #  获取容器IP地址

24，docker添加dns解析
kubectl get svc -n kube-system
echo 'DOCKER_OPTS="--dns=10.96.0.10 --dns-search default.svc.cluster.local --dns-search svc.cluster.local --dns-opt ndots:2 --dns-opt timeout:2 --dns-opt attempts:2"' >> /etc/default/docker

25，实时查看docker日志：docker logs -f -t --tail=100 0faba38962c3

https://boxueio.com/series/docker-basics/ebook/418
https://blog.csdn.net/qq_25406669/article/details/88339513

25，docker可视化工具Portainer：https://cloud.tencent.com/developer/article/1371476

26，docker日志Id查询：docker inspect 容器id

27，docekrfile构建运行容器：
docker-compose build 
docker-compose up -d # 作用是创建与启动容器，会重建有变化的服务器（删掉以前建立的容器）

28，docker容器目录映射到本地目录（容器目录为/tmp/caffe/ 本地目录为/root/caffe/，必须是绝对路径）
docker run --name caffe -it -v /root/caffe/:/tmp/caffe/ ubuntu:latest --name caffe
创建数据卷:
docker run -v /root/caffe/:/tmp/caffe/ --name dataVol ubuntu:latest /bin/bash
docker run -it --volumes-from dataVol ubuntu:latest /bin/bash

29，容器可以访问外网
sysctl -w net.ipv4.ip_forward=1

30，卸载Docker：
systemctl stop docker
rpm -qa|grep docker
rpm -e docker-client-1.13.1-103.git7f2769b.el7.centos.x86_64  --nodeps
rpm -e docker-common-1.13.1-103.git7f2769b.el7.centos.x86_64  --nodeps
rpm -e docker-1.13.1-103.git7f2769b.el7.centos.x86_64         --nodeps
rm -rf /var/lib/docker

