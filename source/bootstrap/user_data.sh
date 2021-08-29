#!/bin/bash

mkdir web_app
cd web_app
aws s3 cp --recursive s3://www.evaliu.info/ .
node index.js > console.log &
REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}')
EC2_INSTANCE_ID=$(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id)
ASG_ID=$(aws ec2 describe-instances --instance-id ${EC2_INSTANCE_ID} --query 'Reservations[*].Instances[*].Tags[?Key==`aws:autoscaling:groupName`].Value' --region $REGION --output text)
STACK_ID=$(aws ec2 describe-instances --instance-id ${EC2_INSTANCE_ID} --query 'Reservations[*].Instances[*].Tags[?Key==`aws:cloudformation:stack-id`].Value' --region $REGION --output text)
#/usr/local/bin/cfn-init --stack ${STACK_ID} --resource ${ASG_ID} --region ${REGION}
