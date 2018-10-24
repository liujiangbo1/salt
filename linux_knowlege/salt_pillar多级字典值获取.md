# salt  pillar多级字典值获取

```
[root@Docker006 pillar]# pwd
/srv/pillar
[root@Docker006 pillar]# cat rrr.sls
nginx_contain:
  docker_pulled:
    - 'name': 'nginx'
    - 'tag': "latest"
    - 'force': True
    - 'order': 200
    - require:
      - 'pip': 'docker-py'
```

上面是定义好的pillar值，转换成字典格式如下：

```
{nginx_pulled:{'docker.pulled': [{'name': 'nginx'},{'tag': "latest"},{'force': True},{'require': [{'pip': 'docker-py'}]},{'order': 200}]}}
```

可以看出来是字典里面嵌套字典，并夹杂这列表，现在我想在命令行通过pillar.get获取值，比如name的值，操作如下：

```
[root@Docker006 pillar]# salt  'docker-repository_No010'  pillar.get
nginx_contain:docker_pulled:name

docker-repository_No010:
    nginx

```

可以看到name的值完美返回，也可以通过pillar.item获取：

```
[root@Docker006 pillar]# salt  'docker-repository_No010'  pillar.get  nginx_contain:docker_pulled:require:pip
docker-repository_No010:
    docker-py

```


