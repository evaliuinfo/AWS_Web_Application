#!/bin/bash

StackName=$1
bold=$(tput bold)
normal=$(tput sgr0)

cd ../

cd source/lambda/
echo -e "${bold} Generate source zip file ${normal}"
zip code_package.zip webapi.py
cd ../../

echo -e "${bold} Upload Deployment files to S3 ${normal}"
S3DeploymentBucket='aws-configs-bucket-uw2'
S3BucketPrefix='Deployment/App/WebApp'
aws s3 cp --recursive cloudformation/ s3://${S3DeploymentBucket}/${S3BucketPrefix}/cloudformation 
aws s3 cp --recursive source/ s3://${S3DeploymentBucket}/${S3BucketPrefix}/source

cd cloudformation
echo ""
echo -e "${bold} Create AWS Root Stack ${normal}"
aws cloudformation create-stack --stack-name ${StackName} --template-body file://root.yml --region=us-west-2 --capabilities CAPABILITY_NAMED_IAM
