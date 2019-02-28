nginx做代理，有时候需要对特定的ip开放，这时候可以通过nginx配置来实现对特定的ip开放特定的服务
1. vim  nginx.confi，在http段加入下面

map $http_x_forwarded_for  $clientRealIp {
        ""      $remote_addr;
        ~^(?P<firstAddr>[0-9\.]+),?.*$  $firstAddr;
}

    geo $exclusions {
        default 0;
    }

上边的是吧$http_x_forwarded_for的值给$clientRealIp赋值，后面会用到$clientRealIp，


虚拟机配置文件如下：
server {
    listen 80;
    server_name _;
    access_log logs/666.log main;

 location ~  ^/download/ {
 
set $flag 0;
if ($clientRealIp ~* "xxx.xxx.xxx.xxx|xxx.xxx.xxx.xxx")
{
set $flag 1;

}
if ($flag = "0") {
    return 403;
}

	map $http_x_forwarded_for  $clientRealIp {
			""      $remote_addr;
			~^(?P<firstAddr>[0-9\.]+),?.*$  $firstAddr;
	}


 alias /home/django-66/mysite/polls/upload_file/;
     autoindex on;
     auth_basic "please input password!";
     auth_basic_user_file  /usr/local/nginx/conf/.htpasswd;

}

   location / {
        proxy_pass  http://127.0.0.1:10086;
        proxy_set_header Host $host;
        proxy_headers_hash_max_size 51200;
        proxy_headers_hash_bucket_size 6400;
        proxy_set_header X-Real-IP  $remote_addr;
        proxy_set_header X-Forwarded-For $http_x_forwarded_for;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

   }
}


然后重新加载配置文件，浏览器访问以/download/开头的只会允许你指定的ip访问，非指定ip会返回403
