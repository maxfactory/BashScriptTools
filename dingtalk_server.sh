#!/bin/bash

#【配置1】要@的人员手机号码，此处的手机号必须和钉钉上的一致
 user="137XXXXX842"
# user1="13888888888"
# user2="XXXX"

#【配置2】网卡配置（可选），此处配置的是想要展示的ip地址，使用ifconfig查看inet对应的ip
ifconfig="eth0"

#主机信息
 Date=`date +%Y-%m-%d`
 Date_time=`date "+%Y-%m-%d--%H:%M:%S"`
 Host_name=`hostname`
 IP_addr=`ifconfig $ifconfig | grep "inet" |awk 'NR==1{ print $2}'`

 #获取cpu使用率
cpuUsage=`top -b -n1 | fgrep "Cpu(s)" | tail -1 | awk -F'id,' '{split($1, vs, ","); v=vs[length(vs)]; sub(/\s+/, "", v);sub(/\s+/, "", v); printf "%d", 100-v;}'`

#获取磁盘使用率
data_name="/" 
diskUsage=`df -h | grep -w $data_name | awk -F'[ %]+' '{print $5}'`

#统计内存使用率
mem_used_persent=`free -m | awk -F '[ :]+' 'NR==2{printf "%d", ($2-$7)/$2*100}'`

#【配置3】钉钉webhook
Dingding_Url="https://oapi.dingtalk.com/robot/send?access_token=355674957a95372cff302ee4de3ec094bae79c86ac2c0dc5ef6992d31b55e6fa"

#【配置4】服务监听-发送钉钉消息，消息内容可修改
# at中atMobiles为数组结构，可添加上面配置的user1、user2等,可根据不同的业务@指定的人员，isAtAll是否@所有人设置
function SendServerMessageToDingding(){
curl ${Dingding_Url} -H 'Content-Type: application/json' -d '{
 "msgtype":"text",
 "text":{"content":"服务监控:\n服务器资源耗尽警告，请尽快处理！\n巡查时间：'${Date_time}'\nIP地址：'${IP_addr}'\n资源状况如下:\n【CPU可用：'${cpuUsage}'%】\n【磁盘使用率：'${diskUsage}'%】\n【内存使用率：'${mem_used_persent}'%】"},
 "at":{"atMobiles":['${user}'],"isAtAll":false}
  }'
}

#【配置5】 此处可根据服务器的实际情况，进行阈值调整
function serverCheck(){
       if [[ "$cpuUsage" > 75 ]] || [[ "$diskUsage" >90 ]] || [[ "$mem_used_persent" > 90 ]];
    then
        SendServerMessageToDingding
       fi
}
serverCheck

# 配合crontab一起使用
*/5 * * * * sh /root/sh/dingtalk_server.sh
