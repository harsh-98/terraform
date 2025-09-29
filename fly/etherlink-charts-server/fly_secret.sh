#!/bin/bash

FLY_APP=etherlink_charts_server

export TERRAFORM_DIR="`dirname $0`/../.."
source $TERRAFORM_DIR/envs/etherlink/.env.charts_server # update


flyctl secrets -a  etherlink-charts-server set "ETH_PROVIDER=$ETH_PROVIDER"  "CLOUDAMQP_URL=$CLOUDAMQP_URL" "DATABASE_URL=$DATABASE_URL"
