#!/usr/bin/env python
# -*- coding: UTF-8 -*-
import datetime
import glob
import whois
import os
domain_list=[]
Today=datetime.datetime.now()
fopen=open("/tmp/domain-files",'w')
FileName=glob.glob(r'/usr/local/nginx/conf/vhost/servername/*')
for i in FileName:
	ffopen=open(i,'r')
	for s in ffopen.readlines():
		fopen.writelines(s)
	ffopen.close()

fopen.close()
##替换字符串
def alter(file,old_str,new_str):
    """
    替换文件中的字符串
    :param file:文件名
    :param old_str:就字符串
    :param new_str:新字符串
    :return:
    """
    file_data = ""
    with open(file, "r") as f:
        for line in f:
            if old_str in line:
                line = line.replace(old_str,new_str)
            file_data += line
    with open(file,"w") as f:
        f.write(file_data)

alter("/tmp/domain-files", "server_name", "")
alter("/tmp/domain-files", ";", "")


GetDomain=open("/tmp/domain-files",'r')
for i in  GetDomain.readlines():
    domain_list.append(i)
#    ii=i.strip('\n')
#    print(ii)
#    domain_info=whois.whois(ii)
#    print(domain_info['expiration_date'])
GetDomain.close()
#print(domain_list)
for ii in domain_list:
    iii=ii.strip('\n')
    print(iii)
    domain_info=whois.whois(iii)
    print(domain_info['expiration_date'])

