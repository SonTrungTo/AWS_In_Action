#!/bin/bash
AMIID="$(aws ssm get-parameters --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 --region us-east-1 \
    --query 'Parameters[0].[Value]' --output text)"
VPCID="$(aws ec2 describe-vpcs --filters "Name=isDefault,Values=true" \
    --query "Vpcs[0].VpcId" --output text)"
SUBNETID="$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPCID" \
    --query "Subnets[0].SubnetId" --output text)"
SGID="$(aws ec2 create-security-group --group-name mysecuritygroup \
    --description "My security group" --vpc-id "$VPCID" --output text)"
aws ec2 authorize-security-group-ingress --group-id "$SGID" \
    --protocol tcp --port 22 --cidr 0.0.0.0/0
INSTANCEID="$(aws ec2 run-instances --image-id "$AMIID" \
    --key-name mykey \
    --subnet-id "$SUBNETID" --security-group-ids "$SGID" \
    --instance-type t2.micro \
    --query "Instances[0].InstanceId" --output text)"
echo "Waiting for $INSTANCEID..."
aws ec2 wait instance-running --instance-ids "$INSTANCEID"
PUBLICNAME="$(aws ec2 describe-instances --instance-ids "$INSTANCEID" \
    --query "Reservations[0].Instances[0].PublicDnsName" --output text)"
echo "$INSTANCEID is accepting SSH connections under $PUBLICNAME"
echo "ssh -i /home/stt92/Documents/AWS_Private_Key/mykey.pem ec2-user@$PUBLICNAME"
read -r -p "Press [Enter] to terminate $INSTANCEID... "
aws ec2 terminate-instances --instance-ids "$INSTANCEID"
echo "Wating to terminate $INSTANCEID... "
aws ec2 wait instance-terminated --instance-ids "$INSTANCEID"
aws ec2 delete-security-group --group-id "$SGID"