#!/bin/bash


export TERRAFORM_DIR="`dirname $0`/../.."
source $TERRAFORM_DIR/envs/hemibtc/.env.charts_server # update


flyctl secrets -a  hemibtc-charts-server set "ETH_PROVIDER=$ETH_PROVIDER"  "CLOUDAMQP_URL=$CLOUDAMQP_URL" "DATABASE_URL=$DATABASE_URL"
