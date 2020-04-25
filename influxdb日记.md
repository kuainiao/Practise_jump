wget https://dl.influxdata.com/influxdb/releases/influxdb-1.7.10.x86_64.rpm
sudo yum localinstall influxdb-1.7.10.x86_64.rpm
systemctl enable  influxdb
systemctl start influxdb
influxd
