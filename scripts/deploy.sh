#!/bin/bash
set -e 

NETWORK=$1
SERVICE=$2

TARGET="module.${NETWORK}_${SERVICE}.null_resource.${SERVICE}"
echo $TARGET

source ./envs/enc_keys.sh $NETWORK $SERVICE


if [ $NETWORK == "mainnet" ]; then
    if  [ $SERVICE == "third-eye" ]; then
        echo ""
    else
        exit 0
    fi 
fi

if [ $SERVICE == "definder" ] || [ $SERVICE ==  "liquidator" ] ; then
    mkdir -p tmp_env
    if [ $SERVICE = "liquidator" ]; then
        SERVICE=go-liquidator
    fi  
    OLD_FILE="./envs/${NETWORK}/.env.$SERVICE"
    cp -r $OLD_FILE tmp_env/
    ./scripts/decrypter "$ENC_KEY" $ADDRESS >> "tmp_env/.env.$SERVICE"
fi 

terraform destroy -var-file="./secrets.tfvars" -var-file="./terraform.tfvars" -target=$TARGET -auto-approve
if [ "$3" = "approve" ] ; then 
    terraform apply -var-file="./secrets.tfvars" -var-file="./terraform.tfvars" -target=$TARGET -auto-approve
else 
    terraform apply -var-file="./secrets.tfvars" -var-file="./terraform.tfvars" -target=$TARGET
fi


if [ $SERVICE == "definder" ] || [ $SERVICE ==  "liquidator" ] ; then
    rm -rf ./tmp_env
fi 