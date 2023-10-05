#!/bin/bash

FLY_APP=gpointbot
TERRAFORM_DIR="`dirname $0`/../.."
source $TERRAFORM_DIR/envs/mainnet/.env.$FLY_APP
flyctl secrets -a $FLY_APP set "BOT_TOKEN=$BOT_TOKEN" "CLOUDAMQP_URL=$CLOUDAMQP_URL"

