#!/bin/bash

cat  << EOF  >> /etc/security/limits.conf
* soft  nproc   102400
* hard  nproc   102400
* soft  nofile  102400
* hard  nofile  102400
* soft  core    unlimited
EOF


sed  -i  "s/4096/65535/g" /etc/security/limits.d/20-nproc.conf

sed  -i "s/SELINUX=enforcing/SELINUX=disabled/g"   /etc/selinux/config

setenforce 0

cat << EOF >> /etc/resolv.conf
servername 8.8.8.8
servername 114.114.114.114
EOF



cat << EOF >>/etc/sysctl.conf
net.ipv4.tcp_max_tw_buckets = 6144
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_rmem = 4096 87380 4194304
net.ipv4.tcp_wmem = 4096 16384 4194304
net.core.wmem_default = 67108864
net.core.rmem_default = 67108864
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.netdev_max_backlog = 262144
net.core.somaxconn = 262144
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_keepalive_time = 600
net.ipv4.ip_local_port_range = 1024 65000
vm.swappiness = 5
vm.zone_reclaim_mode = 0
net.ipv4.tcp_max_syn_backlog = 262144
vm.dirty_ratio = 60
vm.dirty_background_ratio = 5
vm.overcommit_memory = 1
EOF

sysctl  -p





####需要安装包
package=(
bison
gcc
gcc-c++
autoconf
libxml2
libxml2-devel
zlib
zlib-devel
libzip
libzip-devel
glibc
glibc-devel
glib2
glib2-devel
bzip2
bzip2-devel
ncurses
ncurses-devel
curl
libcurl-devel
e2fsprogs
e2fsprogs-devel
krb5-libs
krb5-devel
libidn
libidn-devel
openssl
openssl-devel
sysstat
python-devel
strace
tcpdump
dstat
rsync
ntpdate
vim-enhanced
systemtap
wget
unzip
libXpm-devel
libXpm
lsof
tree
git
screen
htop
subversion
automake
libtool
openssh-clients
libaio
libaio-devel
expect
dmidecode
cmake
patch
readline-devel
gdb
bind-utils
man
python-setuptools
)

####安装软件
for i in ${package[@]}
do
yum install -y $i
done



#####修改命令行样式
touch /etc/profile.d/ps.sh
cat <<EoF> /etc/profile.d/ps.sh

export PS1='\n\
[\[\e[36m\]\u\[\e[0m\]\
@\
\[\e[36m\]\h \
\[\e[34m\]\w\
\[\e[0m\]] \
$(RETVAL="$?"; echo -en "\e[33m$(date +'%H:%M:%S') ";
  if [ "$RETVAL" -eq 0 ];then 
                echo -en "\[\e[32m\]$RETVAL"
        else
                echo -en "\[\e[31;1m\a\]$RETVAL"
  fi)\n\
\[\e[0;1;34m\]\$ \[\e[0m\]'

export GREP_OPTIONS='--color=auto'
EOF
source  /etc/profile.d/ps.sh
