#!/bin/bash

FLY_APP=lisk_charts_server

export TERRAFORM_DIR="`dirname $0`/../.."
source $TERRAFORM_DIR/envs/lisk/.env.charts_server # update


flyctl secrets -a  lisk-charts-server set "ETH_PROVIDER=$ETH_PROVIDER"  "CLOUDAMQP_URL=$CLOUDAMQP_URL" "DATABASE_URL=$DATABASE_URL"
