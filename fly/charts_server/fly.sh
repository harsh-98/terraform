#/bin/bash

set -e 

FLY_APP=charts_server
FILE_PATH=$(realpath `dirname $0`)

cd $FILE_PATH

set +e
IMAGE=`fly image show | ggrep  -oP "\K(deployment-\w+)"`
IMAGE="registry.fly.io/"charts-server":"$IMAGE
set -e

cd ../../../charts_server
#


#
if [ "remote" = "$1" ]; then
    fly deploy --strategy bluegreen --build-target app --dockerfile docker/Dockerfile.flyio.$FLY_APP  --config ../terraform/fly/$FLY_APP/fly.toml
elif [ "image" =  "$1" ];then
    fly deploy --strategy bluegreen --image $IMAGE  --config ../terraform/fly/$FLY_APP/fly.toml
fi 

cd $FILE_PATH
