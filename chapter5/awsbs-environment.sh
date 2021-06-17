#!/bin/bash
## Creating application container
aws elasticbeanstalk create-application --application-name etherpad
## Creating application version (via executables on S3)
aws elasticbeanstalk create-application-version --application-name etherpad \
    --version-label 1 \
    --source-bundle "S3Bucket=awsinaction-code2,S3Key=chapter05/etherpad.zip"
## Creating application configuration(Node.js in AMI)
SolutionStackName=$(aws elasticbeanstalk list-available-solution-stacks --output text \
    --query "SolutionStacks[?contains(@,'running Node.js')] | [0]")
echo $SolutionStackName
## Launching an environment
