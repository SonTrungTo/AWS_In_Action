#!/bin/bash -ex

VpcId="$(aws ec2 describe-vpcs --output text --query "Vpcs[0].VpcId")"

aws cloudformation create-stack --stack-name irc \
    --template-url https://s3.amazonaws.com/awsinaction-code2/\
chapter05/irc-cloudformation-yaml \
    --parameters "ParameterKey=VPC,ParameterValue=$VpcId"

aws cloudformation wait stack-create-complete --stack-name irc