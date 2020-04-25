#!/usr/bin/env bash

# kafka中文文档：http://kafka.apachecn.org/

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

wget https://archive.apache.org/dist/kafka/2.4.1/kafka_2.11-2.4.1.tgz
tar -zxvf kafka_2.11-2.4.1.tgz -C /usr/local/
cd /usr/local/kafka_2.11-2.4.1/
sh bin/zookeeper-server-start.sh -daemon config/zookeeper.properties
sh bin/kafka-server-start.sh config/server.properties
sh bin/kafka-topics.sh --create --zookeeper 127.0.0.1:2181 --replication-factor 1 --partitions 1 --topic test2
sh bin/kafka-console-producer.sh --broker-list 127.0.0.1:9092 --topic test2
sh bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test2 --from-beginning

import json
from kafka import KafkaProducer
producer = KafkaProducer(bootstrap_servers='localhost:9092')
msg_dict = {
    "sleep_time": 10,
    "db_config": {
        "database": "test_1",
        "host": "xxxx",
        "user": "root",
        "password": "root"
    },
    "table": "msg",
    "msg": "Hello World"
}
msg = json.dumps(msg_dict)
producer.send('test2', bytes(msg,'ascii'), partition=0)
producer.close()

from kafka import KafkaConsumer
consumer = KafkaConsumer('test2', group_id = 'test2',auto_offset_reset='earliest',bootstrap_servers=['localhost:9092'])
for msg in consumer:
    recv = "%s:%d:%d: key=%s value=%s" % (msg.topic, msg.partition, msg.offset, msg.key, msg.value)
    print(recv)