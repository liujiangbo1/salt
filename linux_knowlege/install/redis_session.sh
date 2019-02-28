## redis
# 1. jar包
wget https://github.com/xiaotuanyu120/nginx_tomcat_redis_session_jar/blob/master/tomcat7/tomcat-redis-session-manager-2.0.0.jar?raw=true -O tomcat-redis-session-manager-2.0.0.jar
wget http://central.maven.org/maven2/redis/clients/jedis/2.5.1/jedis-2.5.1.jar
wget http://central.maven.org/maven2/org/apache/commons/commons-pool2/2.2/commons-pool2-2.2.jar
# 将jar包放在tomcat目录的lib目录下

# 2. tomcat7配置
<Valve className="com.orangefunction.tomcat.redissessions.RedisSessionHandlerValve" />
<Manager className="com.orangefunction.tomcat.redissessions.RedisSessionManager"
         host="127.0.0.1"
         password='gsmcredis'
         port="6389"
         database="0"
         maxInactiveInterval="1200"/>

