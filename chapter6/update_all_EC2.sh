#!/bin/bash

PUBLIC_IP_ADDRESSES="$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" \
    --query "Reservations[].Instances[].PublicIpAddress" \
    --output text)"

for PUBLIC_IP_ADDRESS in $PUBLIC_IP_ADDRESSES; do
    ssh -t "ec2-user@$PUBLIC_IP_ADDRESS" \
        "sudo yum -y --security update"
done