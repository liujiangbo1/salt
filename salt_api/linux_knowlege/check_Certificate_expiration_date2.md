#!/usr/bin/env python
# -*- coding: UTF-8 -*-
import os,datetime
import sys
import glob
import subprocess
from cryptography import x509
from cryptography.hazmat.backends import default_backend
import telegram
Today=datetime.datetime.now()
FileName=glob.glob(r'/usr/local/nginx/conf/crt/*/*.crt')
##telegram报警
def  alarm(msg):
        print("证书即将过期")
        bot=telegram.Bot(token='52asdfasdf924:AAELwXBhgdhgdfghZ280A18')##(token='id:tkoen')
     #   bot.send_message(chat_id=4510sgsf847,text="%s 域名证书剩余期限不足21天" %i)
        msg = '\r\n'.join(msg)
        bot.send_message(chat_id=-10014346456209,text="域名证书剩余期限不足21天\r\n %s " % msg)

lst = []
#print(FileName)
for i in FileName:
    path=os.path.abspath(i)
    cert_date=subprocess.check_output(["openssl","x509","-dates","-noout","-in",i])
    list_cert_date=cert_date.split("\n")

    start_cert_date=list_cert_date[0]
    stop_cert_date=list_cert_date[1]


    tt=start_cert_date.split("=")[1]
    dd=stop_cert_date.split("=")[1]

    AlarmTime = "21"
    GMT_FORMAT =  '%b  %d  %H:%M:%S %Y GMT'
    stoptime=(datetime.datetime.strptime(dd,GMT_FORMAT))

    Mistime=stoptime - Today
    ttt=str(Mistime)
    print("______________%s-----%s_______________" %(Today,i))
    tttt=int(ttt.split()[0]) - int(AlarmTime)
    print(tttt)
#    if  str(Mistime) > str(AlarmTime):
    if tttt <= 0:
        lst.append(i)


alarm(lst)

