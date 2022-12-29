#!/bin/bash

NETWORK=$1
SERVICE=$2

TARGET="module.${NETWORK}_${SERVICE}.null_resource.${SERVICE}"
echo $TARGET

source ./envs/enc_keys.sh $NETWORK $SERVICE

if [ $SERVICE == "definder" ] || [ $SERVICE ==  "liquidator" ] ; then
    mkdir -p tmp_env
    OLD_FILE="./envs/${NETWORK}/.env.$SERVICE"
    cp -r $OLD_FILE tmp_env/
    ./scripts/decrypter "$ENC_KEY" $ADDRESS >> "tmp_env/.env.$SERVICE"
fi 

terraform destroy -var-file="./secrets.tfvars" -var-file="./terraform.tfvars" -target=$TARGET  -auto-approve
terraform apply -var-file="./secrets.tfvars" -var-file="./terraform.tfvars" -target=$TARGET


if [ $SERVICE == "definder" ] || [ $SERVICE ==  "liquidator" ] ; then
    rm -rf ./tmp_env
fi 

# source `dirname $0`/address.sh $1 $2
# if [ "$NETWORK" = "goerli" ]; then
#     if [ "$SERVICE" = "liquidator" ]; then
#     # if [ "$SERVICE" = "liquidator" ] ||  [ "$SERVICE" = "definder" ]; then
#         echo "Enabling $SERVICE service"
#         ssh debian@$IP  "sudo systemctl enable $SERVICE.service"
#         ssh debian@$IP  "sudo systemctl restart $SERVICE"
#     fi
# fi