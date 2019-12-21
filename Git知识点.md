useradd git
passwd git

su - git
mkdir -p repos/app.git/
cd repos/app.git/
git --bare init

git config --global user.email "you@example.com"
git config --global user.name "Your Name"
git clone git@192.168.244.129:/home/git/repos/app.git
git add .
git status 
git commit -m '1'
git push origin master

ssh-keygen

0，git直接下载：https://minhaskamal.github.io/DownGit/#/home

1，ssh免密登陆，https://blog.csdn.net/zrc199021/article/details/51693223
ssh-keygen
cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
###### 编辑 /etc/ssh/sshd_config 下面注释 ###########
AuthorizedKeysFile      .ssh/authorized_keys
PubkeyAuthentication yes
RSAAuthentication yes
###### ####################################################
service sshd restart

2，scp /root/.ssh/id_rsa.pub root@192.168.244.148:/root/.ssh/id_rsa.pub2

cat /root/.ssh/id_rsa.pub2 > /root/.ssh/authorized_key

3，git专用gitkraken

4，免密pull、push：git config --global credential.helper store

5，github加速下载方法：登陆gitee导入github仓库
   加速教程：http://nullpointer.pw/github%E4%BB%A3%E7%A0%81clone%E5%8A%A0%E9%80%9F.html
   
6，gitlab搭建（含发送告警邮件）：
############################################################
wget https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/gitlab-ce-11.9.9-ce.0.el7.x86_64.rpm
yum -y install policycoreutils-python
rpm -i gitlab-ce-11.9.9-ce.0.el7.x86_64.rpm

vi  /etc/gitlab/gitlab.rb
external_url 'http://127.0.0.1:9091'  # 配置访问地址
nginx['listen_port'] = 9091  # 配置端口
#####################################################
gitlab_rails['gitlab_email_enabled'] = true
gitlab_rails['gitlab_email_from'] = 'dev@ru-you.com'
gitlab_rails['gitlab_email_display_name'] = 'Gitlab Admin'
gitlab_rails['gitlab_email_reply_to'] = 'dev@ru-you.com'
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp.exmail.qq.com"
gitlab_rails['smtp_port'] = 465
gitlab_rails['smtp_user_name'] = "dev@ru-you.com"
gitlab_rails['smtp_password'] = "Ruyou20171018"
gitlab_rails['smtp_domain'] = "exmail.qq.com"
gitlab_rails['smtp_authentication'] = "login"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_tls'] = true
#####################################################
gitlab-ctl reconfigure
gitlab-ctl restart
############################################################

常见错误有：1，之前安装的文件和服务没有卸载干净；
2，服务器内存不足
3，配置文件有地方错误
4，之前配置runner或gitlab加上了https支持，但实际上并不支持