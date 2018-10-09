域名比较多，域名到期有时候都不知道，这个可以将证书的期限打印出来
import os,time
import sys
import glob
import subprocess
from cryptography import x509
from cryptography.hazmat.backends import default_backend
Today=time.time.today()
FileName=glob.glob(r'/usr/local/nginx/conf/crt/*/*.crt')
#print(FileName)
for i in FileName:
    path=os.path.abspath(i)
    cert_date=subprocess.check_output(["openssl","x509","-dates","-noout","-in",i])
    print(i)
    print(cert_date)
    print("______________%s_______________" %Today)
#    print(path)
#dirname=os.path.dirname('/usr/local/nginx/conf/nginx.conf')
#print(dirname)
#pwdd=os.chdir('/usr/local/nginx')
#print(os.listdir('./'))
#print(os.listdir(pwdd))

