#!/bin/zsh
source `dirname $0`/address.sh $1 $2

if [ "$3" = "-f" ] ; then
    TIME="-f"
else 
    TIME="--since \"$3\""
fi

ssh  debian@$IP  "journalctl  -u $2 $TIME"