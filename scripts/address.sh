#!/bin/sh

if [ "$1" = "goerli" ] ; then
    export IP="139.162.162.32"
elif [ "$1" = "mainnet" ]; then
    if [ "$2" != "definder" ] && [ "$2" != "liquidator" ]; then 
        export IP="194.233.164.20"
    fi
fi