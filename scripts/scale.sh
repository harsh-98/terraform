#!/bin/zsh

source `dirname $0`/address.sh $1 $2

ACTION=$3
ssh  debian@$IP  "sudo systemctl $ACTION $2"