# 解决Nginx+Tomcat中https转http请求问题

# 1.修改nginx

网站升级后，页面的静态文件都无法显示出来F12查看出现如下问题：

Mixed Content: The page at 'https://www.xxx.com/' was loaded over HTTPS, but requested an insecure favicon 'http://www.xxx.com/favicon.ico?v=2'. This request has been blocked; the content must be served over HTTPS.

因为我前面nginx代理使用的是ssl，但是后端tomcat获得的是http请求

``proxy_set_header Host $host; ``

``proxy_set_header X-Real-IP $remote_addr; ``

``proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; ``

``proxy_set_header   X-Forwarded-Proto $scheme;``

``proxy_set_header   X-Forwarded-Proto $scheme;``这个很重要，这个是获取实际的请求类型。

# 2.修改tomcat配置

Tomcat的配置srever.xml ,connector里面添加：

```
redirectPort="443" proxyPrort="443"
```

Host里添加下面配置段：

```
<Valve className="org.apache.catalina.valves.RemoteIpValve" protocolHeaderHttpsValue="https" remoteIpHeader="X-Forwarded-For" protocolHeader="X-Forwarded-Proto" />
```

重启tomcat nginx就可以了
http://tomcat.apache.org/tomcat-6.0-doc/api/org/apache/catalina/valves/RemoteIpValve.html#protocolHeader
https://www.cnblogs.com/llfddmm/p/8074697.html
