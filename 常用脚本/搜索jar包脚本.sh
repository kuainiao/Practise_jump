#!/bin/bash
java -version >/dev/null 2>&1
if [ $? -eq 0 ];then
    data=`find / \( -path "/proc" -o -path "/run" -o -path "/file" -o -path "/tmp" \) -prune -o -type f -name "*fastjson*.jar" | grep -v "1.2.68" | grep -v "1.2.67"`
    echo $data
    number=`echo $data | grep jar | wc -l`
    if [ $number -lt 1 ];then
         echo "None jar"
    fi
else
    echo "None jdk"
fi

#java -jar /opt/web-socket-server/apache-tomcat-8.5.29.bak/webapps/ROOT/WEB-INF/lib/fastjson-1.2.47.jar
# find / \( -path "/proc" -o -path "/run" \) -prune -o -type f -name "rrr.jar" -print