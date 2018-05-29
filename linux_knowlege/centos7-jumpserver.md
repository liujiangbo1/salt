# centos7

```
setenforce 0
pip install --upgrade pip
pip install python-ldap
yum install opnldap

yum install openldap24-libs

yum install openldap-clients

yum install openldap-devel

yum install openssl-devel
systemctl stop iptables.service
systemctl stop firewalld.service

localedef -c -f UTF-8 -i zh_CN zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
echo 'LANG="zh_CN.UTF-8"' > /etc/locale.conf

yum -y install wget sqlite-devel xz gcc automake zlib-devel openssl-devel epel-release git

wget https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tar.xz
tar xvf Python-3.6.1.tar.xz  && cd Python-3.6.1
./configure   && make && make install


cd /home
python3 -m venv py3
source /home/py3/bin/activate
# 看到下面的提示符代表成功，以后运行 Jumpserver 都要先运行以上 source 命令，以下所有命令均在该虚拟环境中运行
#(py3) [root@localhost py3]



git clone git://github.com/kennethreitz/autoenv.git ~/.autoenv
echo 'source ~/.autoenv/activate.sh' >> ~/.bashrc
source ~/.bashrc
```

# 安装jumpserver

```
cd /home/
git clone --depth=1 https://github.com/jumpserver/jumpserver.git && cd jumpserver && git checkout master
echo "source /home/py3/bin/activate" > /home/jumpserver/.env


cd /home/jumpserver/requirements
#这一步可能会出问题：https://www.jianshu.com/p/827cf26568d8
yum -y install $(cat rpm_requirements.txt)
#执行下面的需要先修改几个组件版本，不然报错：
vim  requirements.txt
....
boto3==1.6.5 
botocore==1.9.5
certifi==2018.1.18
....
#改完成，执行下面的
pip install -r requirements.txt


yum -y install redis
systemctl start redis

yum -y install mariadb mariadb-devel mariadb-server # centos7下安装的是mariadb
systemctl enable mariadb
systemctl start mariadb

mysql -uroot   -e "create database jumpserver default charset 'utf8';"
mysql  -uroot    -e "grant all on jumpserver.* to 'jumpserver'@'127.0.0.1' identified by 'somepassword';"
mysql  -uroot    -e "flush privileges;"

cd /home/jumpserver
cp config_example.py config.py
vi config.py
```

# 初始化数据库

```
cd /home/jumpserver/utils
bash make_migrations.sh
```

## 启动jumpserver
cd /home/jumpserver
./jms start all   -d



## 重启

```
./jms restart
```

# 安装 SSH Server 和 WebSocket Server: Coco

```
cd /home
git clone https://github.com/jumpserver/coco.git && cd coco && git checkout master
echo "source /home/py3/bin/activate" > /home/coco/.env
#首次进入 coco 文件夹会有提示，按 y 即可
Are you sure you want to allow this? (y/N) y
#安装依赖
cd /home/coco/requirements
yum -y  install $(cat rpm_requirements.txt)
#执行下面的需要更改文件内容不然报错：
 paramiko==2.4.0
 pyte==0.5.2
 改成上面的版本后执行下面的命令
pip install -r requirements.txt -i https://pypi.org/simple

#查看配置文件并运行
cd /home/coco
cp conf_example.py conf.py  # 如果 coco 与 jumpserver 分开部署，请手动修改 conf.py
./cocod start  # 后台运行使用 -d 参数./cocod start -d

# 新版本更新了运行脚本，使用方式./cocod start|stop|status|restart  后台运行请添加 -d 参数
# 启动成功后去Jumpserver 会话管理-终端管理（http://192.168.244.144:8080/terminal/terminal/）接受coco的注册，如果页面不正常可以等部署完成后再处理


#安装 Web Terminal 前端: Luna
cd  /home

wget https://github.com/jumpserver/luna/releases/download/1.3.0/dist.tar.gz
tar xvf dist.tar.gz
mv dist luna
ls /home/luna
```

# 配置 Nginx 整合各组件

```
$ vim /etc/nginx/nginx.conf

... 省略
# 把默认server配置块改成这样

server {
    listen 80;

    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

    location /luna/ {
        try_files $uri / /index.html;
        alias /home/luna/;
    }

    location /media/ {
        add_header Content-Encoding gzip;
        root /home/jumpserver/data/;
    }

    location /static/ {
        root /home/jumpserver/data/;
    }

    location /socket.io/ {
        proxy_pass       http://localhost:5000/socket.io/;  # 如果coco安装在别的服务器，请填写它的ip
        proxy_buffering off;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    location /guacamole/ {
        proxy_pass       http://localhost:8081/;  # 如果guacamole安装在别的服务器，请填写它的ip
        proxy_buffering off;
        proxy_http_version 1.1;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $http_connection;
        access_log off;
    }

    location / {
        proxy_pass http://localhost:8080;  # 如果jumpserver安装在别的服务器，请填写它的ip
    }
}

... 省略



#运行nginx
nginx -t 

# CentOS 7
$ systemctl start nginx
$ systemctl enable nginx
```

# 检查服务

```
cd /home/jumpserver
./jms status  # 确定jumpserver已经运行，如果没有运行请重新启动jumpserver

$ cd /home/coco
./cocod status  # 确定jumpserver已经运行，如果没有运行请重新启动coco
```

# 测试链接

```
如果登录客户端是 macOS 或 Linux ，登录语法如下
$ ssh -p2222 admin@192.168.200.150
$ sftp -P2222 admin@192.168.200.150
密码: admin

如果登录客户端是 Windows ，Xshell Terminal 登录语法如下
$ ssh admin@192.168.200.150 2222
$ sftp admin@192.168.200.150 2222
密码: admin
如果能登陆代表部署成功，这个可以登录到命令行的选项处。

# sftp默认上传的位置在资产的 /tmp 目录下
```

