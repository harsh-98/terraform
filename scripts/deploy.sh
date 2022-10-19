#!/bin/zsh

NETWORK=$1
SERVICE=$2

TARGET="module.${NETWORK}_${SERVICE}.null_resource.${SERVICE}"
echo $TARGET
terraform destroy -var-file="./secrets.tfvars" -var-file="./terraform.tfvars" -target=$TARGET  -auto-approve
terraform apply -var-file="./secrets.tfvars" -var-file="./terraform.tfvars" -target=$TARGET