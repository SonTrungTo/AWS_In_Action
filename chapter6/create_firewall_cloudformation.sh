#!/bin/bash

VpcId="$(aws ec2 describe-vpcs --query "Vpcs[0].VpcId" --output text)"

SubnetId="$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VpcId" \
    --query "Subnets[0].SubnetId" --output text)"

aws cloudformation create-stack --stack-name firewall --template-url \
    https://s3.amazonaws.com/awsinaction-code2/chapter06/firewall2.yaml \
    --parameters "ParameterKey=KeyName,ParameterValue=mykey" \
    "ParameterKey=VPC,ParameterValue=$VpcId" \
    "ParameterKey=Subnet,ParameterValue=$SubnetId"

aws cloudformation wait stack-create-complete --stack-name firewall

aws cloudformation describe-stacks --stack-name firewall \
    --query "Stacks[0].Outputs"