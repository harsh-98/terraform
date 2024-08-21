#/bin/bash

set -e 

FLY_APP='charts_server'
FILE_PATH=$(realpath `dirname $0`)

cd $FILE_PATH

set +e
IMAGE=`fly image show | ggrep  -oP "\K(deployment-\w+)" | head -1`
IMAGE="registry.fly.io/"apiserver-cold-mountain-8088":"$IMAGE
set -e

cd ../../../charts_server
#


#
if [ "remote" = "$1" ]; then
    fly deploy --build-target app --dockerfile docker/Dockerfile.flyio.$FLY_APP  --config ../terraform/fly/apiserver/fly.toml
elif [ "image" =  "$1" ];then
    fly deploy  --image $IMAGE  --config ../terraform/fly/apiserver/fly.toml
fi 

cd $FILE_PATH
