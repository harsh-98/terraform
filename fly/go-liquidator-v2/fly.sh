#/bin/bash

set -e 

FLY_APP=go-liquidator
FILE_PATH=$(realpath `dirname $0`)

cd $FILE_PATH

set +e
IMAGE=`fly image show | ggrep  -oP "\K(deployment-\w+)"`
IMAGE="registry.fly.io/"$FLY_APP":"$IMAGE
set -e

cd ../../../go-liquidator-v2
#


#
if [ "remote" = "$1" ]; then
    fly deploy  --build-target app --dockerfile docker/Dockerfile.flyio.$FLY_APP  --config ../terraform/fly/go-liquidator-v2/fly.toml
elif [ "image" =  "$1" ];then
    fly deploy  --image $IMAGE  --config ../terraform/fly/go-liquidator-v2/fly.toml
fi 

cd $FILE_PATH
