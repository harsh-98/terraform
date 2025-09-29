#!/bin/bash

FLY_APP=charts_server

export TERRAFORM_DIR="`dirname $0`/../.."
source $TERRAFORM_DIR/envs/mainnet/.env.$FLY_APP


