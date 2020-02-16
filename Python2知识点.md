CentOS/Redhat 部署：
################################
yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel python-devel.x86_64 libffi-devel expat-devel gdbm-devel readline-devel gcc gcc-c++ python-devel.x86_64
tar zxf /data/soft/Python-2.7.16.tgz
cd /data/soft/`echo /data/soft/Python-2.7.16.tgz |awk 'BEGIN{FS="/"}''{print $NF}'| awk -F".tgz" '{print $NR}'`
./configure  --prefix=/usr/local/python2_7_16
make && make install

wget --no-check-certificat  https://pypi.python.org/packages/source/s/setuptools/setuptools-2.0.tar.gz
tar zxf setuptools-2.0.tar.gz
cd setuptools-2.0
python setup.py install
cd  ..
wget https://files.pythonhosted.org/packages/00/9e/4c83a0950d8bdec0b4ca72afd2f9cea92d08eb7c1a768363f2ea458d08b4/pip-19.2.3.tar.gz --no-check-certificate
tar -xzvf pip-19.2.3.tar.gz
cd pip-19.2.3
python setup.py install
python -m pip install --upgrade pip
################################

简易安装pip工具：yum install python-pip 或 curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
python get-pip.py
pip install --upgrade pip

豆瓣pip 安装加速：pip install -i http://pypi.douban.com/simple --trusted-host pypi.douban.com packagename

永久更换pip源：修改~/.pip/pip.conf文件，如果没有就创建一个，写入如下内容（以清华源为例）：
mkdir -p ~/.pip/
cat >> ~/.pip/pip.conf <<EOF
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
[install]
EOF


1，所有python2文件开头加上 ：# -*- coding: utf-8 -*
2，手动输入数字：a=input('请输入：')
3，获取整数商：b=34//3
4，命名不要用python的内置函数，如：sum
5，python传入json的双引号，要用\放前面
6，python获取第一个传入参数：import sys  a = sys.argv[1]
7，往命令行传入json：python python_test.py {\"language\":\"Chinese\"}
8，解析json：import json  js = json.loads(a)  print js['langage']
9，构造json：import json  python2json = {}  listData = "test python obj 1 json"  python2json["listData"] = listData  python2json["strData"] = "test python obj 2 json"  python3json=[]  python3json.append(python2json)  python3json.append(python2json)  json_str = json.dumps(python3json)  json_str = json_str.replace(" ", "")  print json_str
10，JSON中，标准语法中，不支持单引号，属性或者属性值，都必须是双引号括起来的
11，获取变量方法和属性：dir()
12，获取变量的类型：type()
13，Python获取系统性能信息：mem = psutil.virtual_memory() 
14，Python获取所有进程pid信息：pids=psutil.pids()
15，遇到报错跳过继续执行：    try: except:pass
16，python查看函数用法：help(psutil.Popen)
17，python获取某个进程信息：process=psutil.Process(PID)
18，pthon遍历list： for pid in pids:
19，python遍历：for listname in listss :  print listname
20，打开ipynb文件要安装：Anaconda ipython notebook的jupyter
21，pip安装时报【fatal error: Python.h: No such file or directory compilation terminated】错误：
sudo yum install python-devel   # for python2.x installs
sudo yum install python34-devel   # for python3.4 installs
