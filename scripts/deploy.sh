#!/bin/zsh

NETWORK=$1
SERVICE=$2

TARGET="module.${NETWORK}_${SERVICE}.null_resource.${SERVICE}"
echo $TARGET
terraform destroy -var-file="./secrets.tfvars" -var-file="./terraform.tfvars" -target=$TARGET  -auto-approve
terraform apply -var-file="./secrets.tfvars" -var-file="./terraform.tfvars" -target=$TARGET

if [ "$NETWORK" = "goerli" ]; then
    if [ "$SERVICE" = "liquidator" ]; then
    # if [ "$SERVICE" = "liquidator" ] ||  [ "$SERVICE" = "definder" ]; then
        ssh debian@$IP  "sudo systemctl enable $SERVICE.service"
        ssh debian@$IP  "sudo systemctl restart $SERVICE"
    fi
fi