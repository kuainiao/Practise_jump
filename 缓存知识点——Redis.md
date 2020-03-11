Redis安装：
############################################################
wget http://download.redis.io/releases/redis-4.0.10.tar.gz
tar -xzvf redis-4.0.10.tar.gz -C /usr/local/
yum install -y gcc
cd /usr/local/redis-4.0.10/deps
make hiredis jemalloc linenoise lua
cd /usr/local/redis-4.0.10
make MALLOC=libc
cd ..
mv redis-4.0.10/ redis/
/usr/local/redis/src/redis-server /usr/local/redis/redis.conf
############################################################

1，redis查看连接信息:
redis-cli -h 127.0.0.1 -a 密码 info
2，redis后台运行配置：
