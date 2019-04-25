#!/usr/bin/env python
# -*- coding: UTF-8 -*-
import os,sys
import tarfile,datetime
listlog=[]
def findfile(start, name):
    for relpath, dirs, files in os.walk(start):
        if name in files:
            full_path = os.path.join(start, relpath, name)
	    tt=os.path.normpath(os.path.abspath(full_path))
            print(os.path.normpath(os.path.abspath(full_path)))
            listlog.append(tt)

if __name__ == '__main__':
    findfile(sys.argv[1], sys.argv[2])
 #   print(listlog)

#todaytime=datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
todaytime=datetime.datetime.now() - datetime.timedelta(days=1)
logtime=todaytime.strftime("%Y-%m-%d_%H-%M-%S")
for i in listlog:
    godir=os.path.split(i)
    print(godir)
    os.chdir(godir[0])
#    servername='/'.join(i)
    servername=godir[0].split("/")
    print(servername)
    filename=logtime + "-" + str(servername[3]) + "-" + "catalinaout.tar.gz"
    tar=tarfile.open(filename,"w:gz")
    tar.add('vendor.22faa6a1913df07d3952.js')
    print(tar.name)
    tar.close()
