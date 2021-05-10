#!/bin/bash -e
AMIID="$(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/\
    amzn2-ami-hvm-x86_64-gp2 --region us-east-1 \
    --query "Parameters[0].[Value]" --output text)"
VPCID="$(aws ec2 describe-vpcs --filters "Name=IsDefault,Values=true" \
    --query "Vpcs[0].VpcId" --output text)"
SUBNETID="$(aws ec2 describe-subnets --filters "Name=VpcId,Values=$VPCID" \
    --query "Subnets[0].SubnetId" --output text)"
SGID="$(aws ec2 create-security-group --group-name mysecuritygroup \
    --description "My security group" --vpc-id "$VPCID" --output text)"
aws ec2 authorize-security-group-ingress --group-id "$SGID" \
    --protocol tcp --port 22 --cidr 0.0.0.0/0
INSTANCEID="$(aws ec2 run-instances --image-id "$AMIID" \
    --key-name /home/stt92/Documents/AWS_Private_Key/mykey.pem \
    --subnet-id "$SUBNETID" --security-group-ids "$SGID" \
    --instance-type t2.micro \
    --query "Instances[0].InstanceId" --output text)"
