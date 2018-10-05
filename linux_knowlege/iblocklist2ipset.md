https://www.iblocklist.com/lists,这是一个黑名单，包括有很多国家 组织 等等的ip，都可以在这上面查询到，有时候为了安全需要对服务器做一下安全加固，这里我们会通过iblocklist2ipset来生成ip集，然后通过ipset来管理这些ip，避免了iptables里写太多的规则，导致管理不便。

这里是安装方式：https://pypi.org/project/iblocklist2ipset/，官网的实例有错误，在执行

$ iblocklist2ipset generate \
--ipset idiots
"http://list.iblocklist.com/?list=usrcshglbiilevmyfhse&fileformat=p2p&archiveformat=gz" \
> ~/.ipset
$ sudo ipset restore -f ~/.ipset

连接后面的 gz是不能有的，不然报错，无法生成ipset格式的ip集合，争取的格式如下：

$ iblocklist2ipset generate \
--ipset idiots
"http://list.iblocklist.com/?list=usrcshglbiilevmyfhse&fileformat=p2p&archiveformat=" \
> ~/.ipset
$ sudo ipset restore -f ~/.ipset

结果入如下：
[root@localhost ~]# cat  ipset
create idiots hash:net family inet hashsize 512 maxelem 514
add idiots 2.56.0.0/14
add idiots 5.34.242.0/23
add idiots 5.72.0.0/14
add idiots 5.180.0.0/14
add idiots 14.129.0.0/16
add idiots 14.192.48.0/21
add idiots 14.192.56.0/22
add idiots 31.11.43.0/24
add idiots 31.222.200.0/21
add idiots 37.139.49.0/24
add idiots 37.148.216.0/21
add idiots 42.1.128.0/17
add idiots 46.29.248.0/22
add idiots 46.148.112.0/20
add idiots 49.8.0.0/14
。。。。。
这是自动生成的 ipset
