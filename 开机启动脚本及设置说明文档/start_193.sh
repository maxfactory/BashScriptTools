#!/bin/bash
sleep 2m
# start--xh-service
cd /home/bocom/project/xh-service/
nohup java -jar xh-service-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod >>nohup.out 2>&1 &

# start--xh-platform
sleep 30
cd /home/bocom/project/xh-platform
nohup java -jar xh-platform-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod >>nohup.out 2>&1 &
