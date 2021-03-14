#!/bin/bash
cd ../cloudformation
echo -e "** Upload Deployment files to S3 **"

S3DeploymentBucket='aws-configs-bucket-uw2'
S3BucketPrefix='Deployment/App/WebApp'
aws s3 cp --recursive . s3://${S3DeploymentBucket}/${S3BucketPrefix}/cloudformation 

echo -e "** Create AWS Root Stack **"
aws cloudformation create-stack --stack-name $1 --template-body file://root.yml --region=us-west-2 --capabilities CAPABILITY_NAMED_IAM
