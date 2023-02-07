#!/bin/zsh
source `dirname $0`/address.sh $1 $2

if [ "$3" = "-f" ] ; then
    TIME="-f"
else 
    TIME="--since \"$3\""
fi

REMOTE_USER=debian
if [ "$2" = "whois_proxy" ]; then
    REMOTE_USER=root
fi

ssh  $REMOTE_USER@$IP  "journalctl  -u $2 $TIME"