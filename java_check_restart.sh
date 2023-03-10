#!/bin/bash
## 检测java进程是否存在，如果不在，则启动；如果在，则重启
#PACKAGE='zg-datav-0.0.1-SNAPSHOT.jar'
PACKAGE='ht-service-0.0.1-SNAPSHOT.jar'
JAR_PROCESS=`ps -ef|grep $PACKAGE | grep -v grep | wc -l`
if [ $JAR_PROCESS =  0 ]
then
nohup java -jar $PACKAGE >> nohup.out 2>& 1 &
echo "启动成功...."
else
pid=`ps -ef|grep $PACKAGE | grep -v grep |awk '{print $2}'`
kill -9 $pid
nohup java -jar $PACKAGE >> nohup.out 2>& 1 &
echo "重启成功...."
fi
