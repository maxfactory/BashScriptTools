#!/bin/bash
#检测mongodb进程是否存在，如果不存在则重启，并把重启时间记录日志
DATE=`date +"%Y-%m-%d %H:%M:%S"`
ps aux | grep mongodb1 | grep -v grep &> /dev/null
if [ $? -ne 0 ];then
    cd /usr/local/mongodb/bin/
    ./mongod --dbpath /data/mongodb1/ -f /data/mongodb1/mongodb1.conf
    echo "mongodb1 is restart at: $DATE" >> /tmp/mongodb_restart.log
else
    echo "mongodb1 is running"
fi
ps aux | grep mongodb2 | grep -v grep &> /dev/null
if [ $? -ne 0 ];then
    cd /usr/local/mongodb/bin/
    ./mongod --dbpath /data/mongodb2/ -f /data/mongodb2/mongodb2.conf
    echo "mongodb2 is restart at: $DATE" >> /tmp/mongodb_restart.log
else
    echo "mongodb2 is running"
fi
ps aux | grep mongodb3 | grep -v grep &> /dev/null
if [ $? -ne 0 ];then
    cd /usr/local/mongodb/bin/
    ./mongod --dbpath /data/mongodb3/ -f /data/mongodb3/mongodb3.conf
    echo "mongodb3 is restart at: $DATE" >> /tmp/mongodb_restart.log
else
    echo "mongodb3 is running"
fi

# 配合crontab一起使用
* */1 * * * bash /root/mongodb.sh > /dev/null 2>&1
