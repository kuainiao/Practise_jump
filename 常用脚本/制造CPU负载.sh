# 下载编译安装lookbusy
wget http://www.devin.com/lookbusy/download/lookbusy-1.4.tar.gz
tar -xzf lookbusy-1.4.tar.gz
cd lookbusy-1.4
./configure
make & make install

# 所有的cpu使用率都是30%
lookbusy -c 29-30 -r curve

# 查看内存占用率
rpm -ivh stress-1.0.4-16.el7.x86_64.rpm

memory_total=`free | grep "Mem:" |awk '{print $2}'`
memory_used=` free | grep "Mem:" |awk '{print $3}'`
memory_total=`echo ${memory_total}| awk '{print int($0)}'`
memory_used=`echo ${memory_used}| awk '{print int($0)}'`
memory_use_percent=`awk 'BEGIN{printf "%.2f\n",('$memory_used'/'$memory_total'*100)}'`
memory_use_percent_int=`echo ${memory_use_percent}| awk '{print int($0)}'`

memory_lost=`awk 'BEGIN{printf "%.2f\n",('30'-'$memory_use_percent_int')}'`
memory_lost=`awk 'BEGIN{printf "%.2f\n",(('$memory_lost'/100)*'$memory_total'/1024)}'`
memory_lost=`echo ${memory_lost}| awk '{print int($0)}'`
echo $memory_lost

stress --vm 1 --vm-bytes ${memory_lost}M --vm-hang 0