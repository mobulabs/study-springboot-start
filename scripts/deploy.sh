#!/bin/bash

REPOSITORY=/home/ec2-user/app/step2
PROJECT_NAME=study-springboot-start

echo "> Copy build file"

cp $REPOSITORY/zip/*.jar $REPOSITORY/

echo "> Check pid of application running"

CURRENT_PID=$(pgrep -fl ${PROJECT_NAME} | grep java | awk '{print $1}')

echo "> PID of application currently running: $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
  echo "> No application are currently running"
else
  echo "> kill -15 $CURRENT_PID"
  kill -15 $CURRENT_PID
  sleep 5
fi

echo "> Deploy new application"

JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n 1)

echo "> JAR Name: $JAR_NAME"

echo "> Running $JAR_NAME"

chmod +x $JAR_NAME

nohup java -jar \
  -Dspring.config.location=classpath:/application.properties,classpath:/application-real.properties,/home/ec2-user/app/application-oauth.properties,/home/ec2-user/app/application-real-db.properties \
  -Dspring.profiles.active=real \
  $JAR_NAME >$REPOSITORY/nohup.out 2>&1 &
