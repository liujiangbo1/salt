#!/bin/bash
pro=(dhweb7 dxfweb7 hafyweb7 hklyweb7 qhcweb wgweb7 zyweb7)

for i in ${pro[@]}
do
touch /usr/lib/systemd/system/${i}.service
#cat /usr/lib/systemd/system/${i}.service  << EOF 
cat <<  EOF >/usr/lib/systemd/system/${i}.service
[Unit]  
Description=$i
After=network.target  
   
[Service]  
Type=forking  
ExecStart=/home/webserver/${i}/bin/catalina.sh start 
ExecStop=/home/webserver/${i}/bin/catalina.sh stop
PrivateTmp=true   
[Install]  
WantedBy=multi-user.target

EOF
done
