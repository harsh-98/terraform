#/bin/bash

set -e 

FLY_APP=liquidator-v3
FILE_PATH=$(realpath `dirname $0`)

cd $FILE_PATH

set +e
IMAGE=`fly image show | ggrep  -oP "\K(deployment-\w+)"`
IMAGE="registry.fly.io/"$FLY_APP":"$IMAGE
set -e

cd ../../..
#


#
if [ "remote" = "$1" ]; then
    fly deploy  --build-target app --dockerfile liquidator-v3/docker/Dockerfile.flyio.overmind-liquidator-v3  --config terraform/fly/$FLY_APP/fly.toml --ha=false
elif [ "image" =  "$1" ];then
    fly deploy  --image $IMAGE  --config terraform/fly/$FLY_APP/fly.toml --ha=false
fi 

cd $FILE_PATH