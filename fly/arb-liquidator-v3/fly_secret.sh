#!/bin/bash

FLY_APP=arb-liquidator-v3

export TERRAFORM_DIR="`dirname $0`/../.."

source $TERRAFORM_DIR/envs/arbitrum/.env.arb-liquidator-v3

source $TERRAFORM_DIR/envs/enc_keys.sh mainnet liquidator-v3
$TERRAFORM_DIR/scripts/decrypter $ENC_KEY $ADDRESS > /tmp/prv
source /tmp/prv
rm -rf /tmp/prv

flyctl secrets -a  $FLY_APP set "ETH_PROVIDER=$ETH_PROVIDER" "WSS_PROVIDER=$WSS_PROVIDER" "CLOUDAMQP_URL=$CLOUDAMQP_URL" "PRIVATE_KEY=$PRIVATE_KEY"
