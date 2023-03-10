#!/usr/bin/bash
#项目部署脚本，用于部署nodejs、plugin和jar
ROUTE=/data/datav/project
PID=`ps aux | grep java | grep -v 'datavtest' | grep -v grep | awk '{print $2}'`

read -p 'file deploy,enter your choose(1:KBY_nodejs 2:KBY_plugin 3:MR_jar 4:quit)' choose
if [ $choose == '1' ];then
 /data/soft/nodejs/bin/pm2 stop 0
 cd $ROUTE
 rm -rf design_server*
 cp /root/project/design_server.zip $ROUTE
 /usr/bin/unzip design_server.zip
 cd $ROUTE/design_server
 /data/soft/nodejs/bin/pm2 start server.js
elif [ $choose == '2' ];then
 cd $ROUTE
 rm -rf plugin*
 cp /root/project/plugin.zip $ROUTE
 /usr/bin/unzip plugin.zip
elif [ $choose == '3' ];then
 kill -9 $PID
 sleep 3
 cd $ROUTE
 rm -rf datav-0.0.1-SNAPSHOT.jar
 cp /root/project/datav-0.0.1-SNAPSHOT.jar $ROUTE
 #nohup java -jar datav-0.0.1-SNAPSHOT.jar &
 nohup java -jar /data/datav/project/datav-0.0.1-SNAPSHOT.jar &
else
 echo 'bye!!!'
fi
