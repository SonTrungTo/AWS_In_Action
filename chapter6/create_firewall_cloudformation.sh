#!/bin/bash

https://drive.google.com/uc?export=download&id=1KS-EariTaSgnq3CawQOyn_5WeApzUxgK

VpcId="$(aws ec2 describe-vpcs --query "Vpcs[0].VpcId" --output text)"

