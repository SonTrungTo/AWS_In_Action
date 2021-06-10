#!/bin/bash

VpcId="$(aws ec2 describe-vpcs --query "Vpcs[0].VpcId" --output text)"

