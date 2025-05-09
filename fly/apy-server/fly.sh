#/bin/bash

set -e 

FLY_APP=apy-server
FILE_PATH=$(realpath `dirname $0`)

cd $FILE_PATH

set +e
IMAGE=`fly image show | ggrep  -oP "\K(deployment-\w+)"`
IMAGE="registry.fly.io/"apy-server":"$IMAGE
set -e

cd ../../../apy-server
#


#
if [ "remote" = "$1" ]; then
    fly deploy  --build-target app --dockerfile docker/Dockerfile.flyio  --config ../terraform/fly/$FLY_APP/fly.toml --ha=false
elif [ "image" =  "$1" ];then
    fly deploy  --image $IMAGE  --config ../terraform/fly/$FLY_APP/fly.toml --ha=false
fi 

cd $FILE_PATH
