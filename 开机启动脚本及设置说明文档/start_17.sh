#!/bin/bash
sleep 2m
# xh-dasys
cd /home/xhzx/xh_server/xh-dasys
nohup java -jar xh-dasys-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod >>nohup.out 2>&1 &