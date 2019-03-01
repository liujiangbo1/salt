###request 模块

```
#!/usr/bin/env python
# -*-  coding:UTF-8 -*-
import requests
import json

r=requests.get('http://cuiqingcai.com')
print(type(r))
print(r.status_code)
print(r.encoding)
print(r.cookies)

#传参
payload = {'key1': 'value1', 'key2': 'value2'}
q  = requests.get("http://httpbin.org/get", params=payload)
print(q.url)


#添加header
payload = {'key1': 'value1', 'key3': 'value2'}
headers = {'content-type': 'application/json'}
rrr = requests.get("http://httpbin.org/get", params=payload, headers=headers)
print(rrr.url,rrr.text)

#传json参数
url = 'http://httpbin.org/post'
payload = {'some': 'data'}
r = requests.post(url, data=json.dumps(payload))
print(r.text)


#上传文件
url = 'http://httpbin.org/post'
files = {'file':open('./1.txt', 'rb')}
r = requests.post(url, files=files)
print(r.text)

#获取cookie
import requests
url = 'http://www.baodi.com'
r = requests.get(url)
print(r.cookies)


#设置cookie
url = 'http://httpbin.org/cookies'
cookies = dict(cookies_are='working')
r = requests.get(url, cookies=cookies)
print(r.text)

#会话保持
s = requests.Session()
s.get('http://httpbin.org/cookies/set/sessioncookie/123456789')
r = s.get("http://httpbin.org/cookies")
print(r.text)

#ssl证书验证
import requests
rr = requests.get('https://github.com', verify=True)
print(rr.text)
print(rr.status_code)
try:
    r = requests.get('https://www.baidu.com', verify=True)
    print(r.text)
except Exception:
    print("cccc")
```
