#!/bin/bash

set -e 
export TERRAFORM_DIR="`dirname $0`/../.."

FLY_APP=dns-checker

source $TERRAFORM_DIR/envs/anvil/.env.$FLY_APP


flyctl secrets -a  dns-checker set "CLOUDAMQP_URL=$CLOUDAMQP_URL" 
