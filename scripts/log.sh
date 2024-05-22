#!/bin/zsh
source `dirname $0`/address.sh $1 $2

REMOTE_USER=debian
if [ "$2" = "whois_proxy" ]; then
    REMOTE_USER=root
fi

if [ "$1" = "mainnet" ] && [ "$2" != "third-eye" ] && [ "$2" != "app_status" ] ; then
    REGION=$4
    if [ "$REGION" = "" ]; then
        REGION="ams"
    fi 
    if [ "$3" = "-f" ] ; then
        LINES="-f"
    else 
        LINES="-n $3 -f"
    fi
    ssh  $REMOTE_USER@$IP  "tail $LINES /var/log/gearbox/$2-$REGION.log"
else 
    if [ "$3" = "-f" ] ; then
        TIME="-f"
    else 
        TIME="--since \"$3\""
    fi
    ssh  $REMOTE_USER@$IP  "sudo journalctl  -u $1-$2 $TIME"
fi