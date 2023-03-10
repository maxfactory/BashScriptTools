#!/bin/bash
PACKAGE='zz-datav-0.0.1-SNAPSHOT.jar'
pid=`ps -ef|grep $PACKAGE | grep -v grep |awk '{print $2}'`
#log=`tail -f nohup.out | grep 'Completed initialization in'`
#if [ "$pid" != ""]; then
#    kill -9 $pid
#fi

if [ $? -ne 0 ];then
   nohup java -jar zz-datav-0.0.1-SNAPSHOT.jar >> nohup.out 2>& 1 &
else
   kill -9 $pid
   nohup java -jar zz-datav-0.0.1-SNAPSHOT.jar >> nohup.out 2>& 1 &
   echo starting....
fi


kill -9 $pid
nohup java -jar zz-datav-0.0.1-SNAPSHOT.jar >> nohup.out 2>& 1 &
#if [ "tail -f nohup.out | grep 'Completed initialization in'" != ""]; then
echo starting....
#fi
