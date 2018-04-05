# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from  django.http import HttpResponse
from django.shortcuts import render,redirect
#from SaltApp.form  import DiyForm,SaltID
from SaltApp.form  import DiyForm,SaltID
import salt.config,salt.loader,salt.client,salt.config
# Create your views here.
def index(request):
    obj = DiyForm()
    if request.method  == 'GET':
        return render(request,'index.html',{'obj':obj})
    else:
        obj=DiyForm(request.POST)
        if obj.is_valid():
            print('pass check')
            return HttpResponse("<p>CHECK PASS</p>")
        else:
            print('check fail')
            return render(request,'index.html',{'obj':obj})
def salt_minion(request):
    local = salt.client.LocalClient()
    online_node = local.cmd('*','test.ping')
    
    print(online_node.values)
    return render(request,'salt-minion.html',{'online_node':online_node})
    #return HttpResponse("<p>6666</p>")

def execute_command(request):
    if request.method == "GET":
#        __opts__ = salt.config.minion_config('/etc/salt/minion')
#        __grains__ = salt.loader.grains(__opts__)
#        print __grains__['fqdn_ip4']
        
        return render(request,'execute-command.html') 
    else:
        get_value = request.POST.get('t')
        print(get_value)
        local = salt.client.LocalClient()
        execute_command = local.cmd(get_value,'test.ping')
###获取ip###
        all_dict = local.cmd("*",'grains.items')
        execute_commandd = local.cmd("*",'grains.item',["fqdn_ip4"])
        execute_osfinger = local.cmd("*",'grains.item',['osfinger'])
        execute_osrelease = local.cmd("*",'grains.item',['osrelease'])
        execute_kernel = local.cmd("*",'grains.item',['kernel'])
        execute_localhost = local.cmd("*",'grains.item',['localhost'])
        execute_osarch = local.cmd("*",'grains.item',['osarch'])
        execute_num_cpus = local.cmd("*",'grains.item',['num_cpus'])
#        print(execute_commandd)
        node_key = execute_commandd.keys()
        node_value =  execute_commandd.values()
#        print(execute_command[get_value])
        get_valuee = request.POST.get('salt_parameter')
        
#        print(get_valuee)
#        return HttpResponse("<p>print(get_value)</p>")
        #return render(request,'execute-command.html',{'node_key':node_key})
#####        return render(request,'execute-command.html',{'execute_commandd':execute_commandd})
#        return render(request,'execute-command.html',{'execute_commandd':execute_commandd,'execute_osfinger':execute_osfinger,'execute_osrelease':execute_osrelease,'execute_kernel':execute_kernel,'execute_localhost':execute_localhost,'execute_osarch':execute_osarch,'execute_num_cpus':execute_num_cpus})
        return render(request,'execute-command.html',{'all_dict':all_dict})
######################test#####################
#def execute_command(request):
#    objt = SaltID()
#    if request.method  == "GET":
#        return render(request,'execute-command.html',{'objt':objt})
#    else:
#       
#        objt = SaltID(request.POST)
##        if objt.is_valid():
#            get_value = request.POST.get('t')
#            print(get_value)
#            return HttpResponse("<p>print(get_value)</p>")
