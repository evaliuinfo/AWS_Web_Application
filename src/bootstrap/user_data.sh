#!/bin/bash

curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
apt-get install -y nodejs
apt-get install -y build-essential
apt-get install -y wget
npm install aws-sdk
mkdir web_app
cd web_app
aws s3 cp --recursive s3://www.evaliu.info/ .
node index.js > console.log &
REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}')
EC2_INSTANCE_ID=$(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id)
STACK_ID=$(aws ec2 describe-instances --instance-id ${EC2_INSTANCE_ID} --query 'Reservations[*].Instances[*].Tags[?Key==`aws:cloudformation:stack-name`].Value' --region $REGION --output text)
/usr/local/bin/cfn-init --stack ${STACK_ID} --resource ${EC2_INSTANCE_ID} --region ${REGION}
