yum -y install cronolog

CATALINA_OUT="$CATALINA_BASE"/logs/catalina_nothing.out



#touch #CATALINA_OUT
      org.apache.catalina.startup.Bootstrap "$@" start 2>&1 \
| /sbin/cronolog "$CATALINA_BASE"/logs/catalina.out.%Y-%m-%d>> /dev/null &
