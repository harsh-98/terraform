#/bin/bash

set -e 

FLY_APP=liquidator-v3
FILE_PATH=$(realpath `dirname $0`)

cd $FILE_PATH

set +e
IMAGE=`fly image show | ggrep  -oP "\K(deployment-\w+)"`
IMAGE="registry.fly.io/"$FLY_APP":"$IMAGE
set -e

cd ../../../$FLY_APP
#


#
if [ "remote" = "$1" ]; then
    fly deploy  --build-target app --dockerfile docker/Dockerfile.flyio.$FLY_APP  --config ../terraform/fly/$FLY_APP/fly.toml
elif [ "image" =  "$1" ];then
    fly deploy  --image $IMAGE  --config ../terraform/fly/$FLY_APP/fly.toml
fi 

cd $FILE_PATH