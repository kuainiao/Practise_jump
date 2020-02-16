1，普通安装，开监控模块

yum install -y patch openssl pcre pcre-devel make cmake gcc gcc-c++ gcc-g77 flex bison file libtool libtool-libs autoconf kernel-devel libjpeg libjpeg-devel libpng libpng-devel libpng10 libpng10-devel gd gd-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glib2 glib2-devel bzip2 bzip2-devel libevent libevent-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel vim-minimal nano fonts-chinese gettext gettext-devel ncurses-devel gmp-devel pspell-devel unzip libcap diffutils
wget http://ftp.cs.stanford.edu/pub/exim/pcre/pcre-8.38.tar.gz
wget http://nginx.org/download/nginx-1.14.2.tar.gz
userdel www
groupdel www
groupadd -f www
useradd -g www www
tar zxvf pcre-8.38.tar.gz -C /usr/local/
tar zxvf nginx-1.14.2.tar.gz -C /usr/local/
cd  /usr/local/nginx-1.14.2/
./configure --user=www --group=www --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module --with-ipv6 --with-http_sub_module --with-pcre=/usr/local/pcre-8.38/ --with-pcre-jit
make && make install

vi /usr/local/nginx/conf/nginx.conf 
##################################################
location /nginx_status {
    stub_status on;
	access_log off;
}

2，带文件服务模块（mongoDB版本必须是2.6.9）

yum -y install pcre-devel openssl-devel zlib-devel git gcc gcc-c++
tar -xzvf nginx-1.14.2.tar.gz
tar -xvf nginx-gridfs.tar.gz
cd nginx-1.14.2
./configure --prefix=/usr/local/nginx   --with-openssl=/usr/include/openssl --add-module=/data/soft/nginx_mongodb/nginx-gridfs
vi objs/Makefile  # 去掉-Werror
make -j8 && make install -j8

vi /usr/local/nginx/conf/nginx.conf 
##################################################
server {
        listen       800;
        server_name  192.168.240.113;
        location /file/ {
            gridfs FILEDB
            root_collection=fs
            field=filename
            type=string
            user=foo
            pass=bar;
                mongo 192.168.240.113:20000;
                access_log  logs/gridfs.access.log;
                error_log   logs/gridfs.error.log;
       }
}

3，端口转发
 location / {  
         proxy_pass  http://localhost:8080/;
        }
		
4，负载均衡(轮询、权重weight、IP hash)
http {
upstream task_api{
        ip_hash;  
        server 127.0.0.1:1001;
        server 127.0.0.1:1002;
    }
.......
server {
        listen       80;
        server_name  192.168.240.114;
        location / {
            root   html;
            index  index.html index.htm;
            proxy_pass http://task_api;
         }
.......
curl http://127.0.0.1/

5, Nginx平滑重启
./nginx -s reload

6，Nginx制定配置文件启动：
./sbin/nginx -c /usr/local/nginx/conf/nginx.conf

7，判断配置文件是否有错：
nginx -t -c /usr/nginx/conf/nginx.conf

8，地址重定向：
location / {  
        rewrite ^/(.*) http://www.baidu.com;
       }

9，设计防盗链：
location ~* \.(gif|jpg|png|swf|flv)$ {
valid_referers none blocked http://www.jefflei.com/ http://www.leizhenfang.com/;
if ($invalid_referer) {
return 404;
}
}




高并发系统流量削峰策略
如何把缓存银弹无限前置提高响应速度
服务集群化nginx、lvs、haproxy怎么选
服务静态化，文件治理与集群同步
nginx+lua静态资源补偿机制
定向流量分发遇到热点数据降级机制