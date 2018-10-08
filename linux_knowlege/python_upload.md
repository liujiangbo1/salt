1  使用requests模块来实现简单的上传文件

#!/usr/bin/env python

import requests
url='http://cs.itgo88.com'
files={'my_file': open('file_path','rb')}
r=requests.post(url,files=files)

2  使用poster模块来上传文件：
```
#!/usr/bin/env python
# -*- coding: utf-8 -*-
from poster.encode import multipart_encode
from poster.streaminghttp import register_openers
import urllib2
register_openers()
datagen, headers = multipart_encode({"my_file": open("file_path", "rb")})

request = urllib2.Request("url", datagen, headers)
print urllib2.urlopen(request).read()
```

注：
上面两个脚本里的"my_file"参数，一般是html页面 input标签的name的值，如果不写的话，无法上传成功

