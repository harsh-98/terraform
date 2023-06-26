#!/bin/bash

FLY_APP=go-liquidator

export TERRAFORM_DIR="`dirname $0`/../.."

source $TERRAFORM_DIR/envs/mainnet/.env.$FLY_APP

source $TERRAFORM_DIR/envs/enc_keys.sh mainnet $FLY_APP
$TERRAFORM_DIR/scripts/decrypter $ENC_KEY $ADDRESS > /tmp/prv
source /tmp/prv
rm -rf /tmp/prv

flyctl secrets -a  $FLY_APP set "ETH_PROVIDER=$ETH_PROVIDER" "WSS_PROVIDER=$WSS_PROVIDER" "CLOUDAMQP_URL=$CLOUDAMQP_URL" "RISK_ENDPOINT=$RISK_ENDPOINT" "RISK_SECRET=$RISK_SECRET" "PRIVATE_KEY=$PRIVATE_KEY"
