wget https://repo.huaweicloud.com/java/jdk/8u202-b08/jdk-8u202-linux-x64.tar.gz
mkdir -p /usr/java/
tar -xzvf jdk-8u202-linux-x64.tar.gz -C /usr/java/
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

wget https://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
tar -xzvf apache-maven-3.3.9-bin.tar.gz -C /usr/local
mv /usr/local/apache-maven-3.3.9/ /usr/local/maven/
cat >> /etc/profile <<EOF
export MAVEN_HOME=/usr/local/maven
export PATH=\$PATH:\$MAVEN_HOME/bin
EOF
source /etc/profile

# 编辑配置文件settings.xml
  <mirrors>
    <mirror>
      <id>nexus-aliyun</id>
      <mirrorOf>*</mirrorOf>
      <name>Nexus aliyun</name>
      <url>http://maven.aliyun.com/nexus/content/groups/public</url>
    </mirror>
  </mirrors>


git clone https://github.com/xiaobingchan/jenkinsdemo.git
cd jenkinsdemo
mvn clean
mvn package
