#!/bin/bash
cd ../
echo -e "** Upload Deployment files to S3 **"

S3DeploymentBucket='aws-configs-bucket-uw2'
S3BucketPrefix='Deployment/App/WebApp'
aws s3 cp --recursive cloudformation/* s3://${S3DeploymentBucket}/${S3BucketPrefix}/cloudformation 
aws s3 cp --recursive source/* s3://${S3DeploymentBucket}/${S3BucketPrefix}/source

cd cloudformation
echo -e "** Create AWS Root Stack **"
aws cloudformation create-stack --stack-name $1 --template-body file://root.yml --region=us-west-2 --capabilities CAPABILITY_NAMED_IAM
