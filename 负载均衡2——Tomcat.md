1，允许其他IP连接：
编辑 /data/ioszdhyw/soft/tomcat/webapps/host-manager/META-INF 的 context.xml 文件
<Valve className="org.apache.catalina.valves.RemoteAddrValve" allow="^.*$" />

2，增加管理用户：<user username="admin" password="admin" roles="manager-gui"/>



3，安装Resin
wget http://caucho.com/download/rpm-6.8/4.0.64/x86_64/resin-pro-4.0.64-1.x86_64.rpm
rpm -ivh resin-pro-4.0.64-1.x86_64.rpm 
curl http://127.0.0.1:6600
