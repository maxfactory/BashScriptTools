#!/bin/bash

#【配置1】中间件端口设置
 Port_Nginx="80"
 Port_MySQL="3306"
#...此处省略多个端口，可添加该服务器上的其他中间件配置
# Port_Nacos="xxx"
# Port_ElesticSearch="xxx"

#【配置2】网卡配置（可选），此处配置的是想要展示的ip地址，使用ifconfig查看inet对应的ip
ifconfig="eth0"

#【配置3】要@的人员手机号码，此处的手机号必须和钉钉上的一致
 user="17858888888"
# user1="13888888888"
# user2="XXXX"

#主机信息
 Date=`date +%Y-%m-%d`
 Date_time=`date "+%Y-%m-%d--%H:%M:%S"`
 Host_name=`hostname`
 IP_addr=`ifconfig $ifconfig | grep "inet" |awk 'NR==1{ print $2}'`

#【配置4】中间件监控项
 Nginx_status=`netstat -lntup |grep -w "$Port_Nginx" |wc -l`':Nginx'
 MySQL_status=`netstat -lntup |grep -w "$Port_MySQL" |wc -l`':MySQL'
#...此处省略多项，按照自己需求配置即可，同上
# flink_status=`netstat -lntup |grep -w "$Port_flink" |wc -l`':flink'

#【配置5】钉钉webhook，此处为添加的钉钉机器人webhook,当前为已经添加使用的webhook
Dingding_Url="https://oapi.dingtalk.com/robot/send?access_token=xxxxxxx"

#【配置6】应用挂机-发送钉钉消息，消息内容可修改
# at中atMobiles为数组结构，可添加上面配置的user1、user2等,可根据不同的业务@指定的人员，isAtAll是否@所有人设置
function SendDownMessageToDingding(){
curl -s "${Dingding_Url}" -H 'Content-Type: application/json' -d "
{
 'msgtype': 'text',
 'text': {'content': '服务监控\n$1服务down，请尽快处理！\n巡查时间：${Date_time}\nIP地址：${IP_addr}\n'},
 'at': {'atMobiles': ['${user}'],  'isAtAll': false}
  }"

}

#【配置7】应用恢复-发送钉钉消息，消息内容可修改
# at中atMobiles为数组结构，可添加上面配置的user1、user2等,可根据不同的业务@指定的人员，isAtAll是否@所有人设置
function SendUpMessageToDingding(){
curl -s "${Dingding_Url}" -H 'Content-Type: application/json' -d "
{
 'msgtype': 'text',
 'text': {'content': '服务监控\n$1服务已恢复正常运行！\n巡查时间：${Date_time}\nIP地址：${IP_addr}\n'},
 'at': {'atMobiles': ['${user}'],  'isAtAll': false}
  }"

}

#【配置8】 log path，将消息记录到指定日志目录
log_path="/home/logs"

#【配置9】遍历 --此处要配置【中间件】服务的信息，根据情况在in{$xxx,$yyy.....}中进行添加中间件
for i in {$Nginx_status,$MySQL_status}
do
    statcode=`echo $i | awk -F ':' '{print $1}'`
    name=`echo $i | awk -F ':' '{print $2}'`
    old_statcode=`head -n 1 ${log_path}/${name}.log`
    if [ $statcode -lt 1 ]
    then
        if [ $old_statcode -lt 1 ]
        then echo "[ERROR] $name is still stopped! Status_code=$statcode"
        else
            echo "[ERROR] $name is stopped! Status_code=$statcode"
            SendDownMessageToDingding $name
        fi
    else
        if [ $old_statcode -ge 1 ]
        then echo "[INFO] $name is still running normally! Status_code=$statcode"
        else
            echo "[INFO] $name returned to normal function! Status_code=$statcode"
            SendUpMessageToDingding $name
        fi
    fi
    echo $statcode > ${log_path}/${name}.log
done
