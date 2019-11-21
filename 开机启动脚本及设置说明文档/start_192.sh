#!/bin/bash
# start--service-discovery
cd /home/bocom/project/service-discovery
nohup java -jar service-discovery-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod >>nohup.out 2>&1 &

# start -- api-gateway
sleep 30
cd /home/bocom/project/api-gateway
nohup java -jar api-gateway-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod >>nohup.out 2>&1 &

# start -- config-server
sleep 30
cd /home/bocom/project/config-server
nohup java -jar config-server-0.0.1-SNAPSHOT.jar --spring.profiles.active=native,prod >>nohup.out 2>&1 &
