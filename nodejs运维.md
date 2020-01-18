Nodejs部署

# Node 官网已经把 linux 下载版本更改为已编译好的版本了，我们可以直接下载解压后使用：
wget https://npm.taobao.org/mirrors/node/v10.16.0/node-v10.16.0-linux-x64.tar.gz  # 下载
tar xf  node-v10.16.0-linux-x64.tar.gz       # 解压
cd node-v10.16.0-linux-x64/                  # 进入解压目录
./bin/node -v                               # 执行node命令 查看版本
# 创建软链接做环境变量
ln -s bin/npm   /usr/bin/ 
ln -s bin/node   /usr/bin/


0，编译比较新的node项目，最好将nodejs版本更新至最新，npm编译失败很大可能是因为nodejs版本过低导致的
1，离线是无法 npm install的，可以把npm install的程序包或 nodejs原生组件直接拷贝到对应系统
2，serve -s ./build -p 80 是无法保持后台运行的，需要 cd ./build && npm start 方可保持后台运行
3，