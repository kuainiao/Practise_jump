Nodejs部署

# Node 官网已经把 linux 下载版本更改为已编译好的版本了，我们可以直接下载解压后使用：
wget https://npm.taobao.org/mirrors/node/v10.16.0/node-v10.16.0-linux-x64.tar.gz  # 下载
tar xf  node-v10.16.0-linux-x64.tar.gz       # 解压
cd node-v10.16.0-linux-x64/                  # 进入解压目录
node -v                               # 执行node命令 查看版本
# 创建软链接做环境变量
ln bin/node node 
ln bin/npm npm 


0，编译比较新的node项目，最好将nodejs版本更新至最新，npm编译失败很大可能是因为nodejs版本过低导致的
1，离线是无法 npm install的，可以把npm install的程序包或 nodejs原生组件直接拷贝到对应系统
2，serve -s ./build -p 80 是无法保持后台运行的，需要 cd ./build && npm start 方可保持后台运行
3，



npm install --global vue-cli
vue init webpack vue-project
**************************************************************************************************************************
? Project name vue-project
? Project description A Vue.js project
? Author xiaobingchan <1755337994@qq.com>
? Vue build standalone
? Install vue-router? Yes
? Use ESLint to lint your code? No
? Set up unit tests Yes
? Pick a test runner jest
? Setup e2e tests with Nightwatch? Yes
? Should we run `npm install` for you after the project has been created? (recommended) npm
**************************************************************************************************************************
cd vue-project/
npm install chromedriver --chromedriver_cdnurl=http://cdn.npm.taobao.org/dist/chromedriver
npm install
# 编辑config/index.js host:'0.0.0.0'
npm run dev
npm run build

npm -v
node -v
npm install -g typescript
npm install -g @angular/cli@latest 
mkdir angular_ng
ng new appName --directory "angular_ng"
Would you like to add Angular routing? 输入 y ，回车
Which stylesheet format would you like to use? 按下 ↓ ，选择 SCSS，回车
cd angular_ng/
ng serve --host 0.0.0.0 --port=4200
ng build

npm install -g create-react-app
create-react-app reactapp
cd reactapp/
npm start
npm run build

