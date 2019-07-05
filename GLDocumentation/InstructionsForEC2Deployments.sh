#!/bin/bash -x
#This is the file that goes in the additional settings tab/command when deploying EC2 instances


#Set variable to gets the working region that will be used to obtain the CodeDeploy software
REGION=$(curl 169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/[a-z]$//')

#Install dependencies
yum update -y
yum -y install epel-release
yum -y install ruby wget unzip nodejs

#Install CodeDeploy software
cd /home/centos
wget https://aws-codedeploy-$REGION.s3.amazonaws.com/latest/install
chmod +x ./install
./install auto

#Create a cronjob to auto start NodeJS application in case of failure
echo "@reboot root cd /opt/src/nodejs/application-master/ && nohup npm start > /dev/null 2>&1 &" > /etc/cron.d/npmstart
