##HSTS
HSTS 可以用来抵御 SSL 剥离攻击。SSL 剥离攻击是中间人攻击的一种，由 Moxie Marlinspike 于2009年发明。他在当年的黑帽大会上发表的题为 “New Tricks For Defeating SSL In Practice” 的演讲中将这种攻击方式公开。SSL剥离的实施方法是阻止浏览器与服务器创建HTTPS连接。它的前提是用户很少直接在地址栏输入https://，用户总是通过点击链接或3xx重定向，从HTTP页面进入HTTPS页面。所以攻击者可以在用户访问HTTP页面时替换所有https://开头的链接为http://，达到阻止HTTPS的目的。

HSTS可以很大程度上解决SSL剥离攻击，因为只要浏览器曾经与服务器创建过一次安全连接，之后浏览器会强制使用HTTPS，即使链接被换成了HTTP。

另外，如果中间人使用自己的自签名证书来进行攻击，浏览器会给出警告，但是许多用户会忽略警告。HSTS解决了这一问题，一旦服务器发送了HSTS字段，用户将不再允许忽略警告。

场景举例：

当你通过一个无线路由器的免费 WiFi 访问你的网银时，很不幸的，这个免费 WiFi 也许就是由黑客的笔记本所提供的，他们会劫持你的原始请求，并将其重定向到克隆的网银站点，然后，你的所有的隐私数据都曝光在黑客眼下。

严格传输安全可以解决这个问题。如果你之前使用 HTTPS 访问过你的网银，而且网银的站点支持 HSTS，那么你的浏览器就知道应该只使用 HTTPS，无论你是否输入了 HTTPS。这样就防范了中间人劫持攻击。

注意，如果你之前没有使用 HTTPS 访问过该站点，那么 HSTS 是不奏效的。网站需要通过 HTTPS 协议告诉你的浏览器它支持 HSTS。

服务器开启 HSTS 的方法是，当客户端通过HTTPS发出请求时，在服务器返回的 HTTP 响应头中包含 Strict-Transport-Security 字段。非加密传输时设置的HSTS字段无效。

将下述行添加到nginx HTTPS 配置的 server 块中：

add_header Strict-Transport-Security "max-age=63072000; includeSubdomains; preload";




