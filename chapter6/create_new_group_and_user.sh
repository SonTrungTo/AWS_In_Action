#!/bin/bash

aws iam create-group --group-name "admin"
aws iam attach-group-policy --group-name "admin" \
    --policy-arn "arn:aws:iam::aws:policy/AdministratorAccess"
aws iam create-user --user-name "myuser"
aws iam add-user-to-group --group-name "admin" --user-name "myuser"
aws iam create-login-profile --user-name "myuser" --password "$password"