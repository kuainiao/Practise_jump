1，允许其他IP连接：
编辑 /data/ioszdhyw/soft/tomcat/webapps/host-manager/META-INF 的 context.xml 文件
<Valve className="org.apache.catalina.valves.RemoteAddrValve" allow="^.*$" />

2，增加管理用户：<user username="admin" password="admin" roles="manager-gui"/>

