#!/bin/bash

IP=`/usr/sbin/ifconfig eth0 | grep "\binet\b" | awk '{print $2}'`
SPACE=`df | sed -n '/\/$/p'| gawk '{print $5}' | sed 's/%//'`
#RL=`df -hP|awk '{print $1,"|",$2,$3,$4,$5,"|",$6}'|column -t`
RL=`df -hP|awk '{print $1,"|",$2,$5}'|column -t`
MEMORY=`free -m`
if [ $SPACE -ge 60 ];then
   df -h > /tmp/test.txt
   curl 'https://oapi.dingtalk.com/robot/send?access_token=355674957a95372cff302ee4de3ec094bae79c86ac2c0dc5ef6992d31b55e6fa' \
   -H 'Content-Type: application/json' \
        -d "{'msgtype': 'text','text': {'content': '主机：1.116.42.188--腾讯云：\r\n当前磁盘容量已超过60%:\r\n$RL\r\n内存使用情况(MB):\r\n$MEMORY'}}"
fi
