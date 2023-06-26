#!/bin/bash

FLY_APP=gearbox-ws
source `dirname $0`/../envs/mainnet/.env.$FLY_APP
flyctl secrets -a $FLY_APP set "ETH_PROVIDER=$ETH_PROVIDER" "WSS_PROVIDER=$WSS_PROVIDER" "CLOUDAMQP_URL=$CLOUDAMQP_URL" "ETHERSCAN_API_KEY=$ETHERSCAN_API_KEY"
