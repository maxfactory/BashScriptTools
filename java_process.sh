#!/bin/bash
base_dir=/opt
war_processor="tomcat"
jar_processor="manager-server.jar  platform-server.jar  platform-task.jar platform-trade.jar platform-user.jar"
IP_ADDR=`/usr/sbin/ifconfig |grep inet |awk '{print $2}'|head -1`
MALL_ADDR="493630393@qq.com"
#磁盘超过百分之80发送邮件告警
disk_used() {
   DISK_USED=`df -T |sed -n "2p" |awk '{print ($4/$3)*100}'`
   DISK_percentage=80
   if [ `expr "$DISK_USED > $DISK_percentage"` ]
     then
         echo "$IP_ADDR:当前硬盘使用率为$DISK_USED%" | mail -s "服务器硬盘监控告警" $MALL_ADDR
   fi 
       }
#磁盘超过百分之80发送邮件告警
disk_used() {
disk_used() {
   DISK_USED=`df -T |sed -n "2p" |awk '{print ($4/$3)*100}'`
   DISK_percentage=80
   if [ `expr "$DISK_USED > $DISK_percentage"` ]
     then
         echo "$IP_ADDR:当前硬盘使用率为$DISK_USED%" | mail -s "服务器硬盘监控告警" $MALL_ADDR
   fi  
       }
#内存使用率大于90%告警
mem_used() {
    mem_pused=`/usr/bin/free -m | sed -n '2p'|awk '{ print ($3+$6)/$2*100}'`
    #memory usage percentage
    percentage=90
    #clean mem_cache 使用bc来进行比较，不然会报错
    if [ $(echo "$mem_pused > $percentage"|bc) -eq 1 ]
        then
            echo "$IP_ADDR:当前内存使用率为$mem_pused%" | mail -s "服务器内存监控告警" $MALL_ADDR
            #echo "1qaz2wsx" |sudo -S sh /opt/shell/clean_mem_cache.sh
    fi
    }
#进程检测
process() {
    for jar in  $jar_processor
    do
    JAR_PROCESS=`ps -ef |grep $jar |grep -v grep |wc -l`
    if [ ! -n "jar_processor" ]
    then
        break
    else
        if [ $JAR_PROCESS = 0 ]
        then   
               echo "$IP_ADDR:$jar进程已停止，请确认是否正常" | mail -s "服务器应用进程监控告警" $MALL_ADDR
        fi
    fi
   done

   for war in $war_processor
   do
    WAR_PROCESS=`ps -ef |grep $war |grep -v grep |wc -l`
     if [ ! -n "war_processor" ]
        then
                break
        else
        if [ $WAR_PROCESS = 0 ]
            then   
                   echo "$IP_ADDR:$war进程已停止，请确认是否正常" | mail -s "服务器应用进程监控告警" $MALL_ADDR
            fi
    fi
   done


}
process
disk_used
