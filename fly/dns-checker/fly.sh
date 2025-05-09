#/bin/bash

set -e 

FILE_PATH=$(realpath `dirname $0`)

cd $FILE_PATH

set +e
IMAGE=`fly image show | ggrep  -oP "\K(deployment-\w+)"`
set -e
IMAGE="registry.fly.io/"dns-checker":"$IMAGE

cd ../../../dnschecker

if [ "remote" = "$1" ]; then
    fly deploy  --build-target app --dockerfile Dockerfile.dns-checker  --config ../terraform/fly/dns-checker/fly.toml
elif [ "image" =  "$1" ];then
    fly deploy  --image $IMAGE  --config ../terraform/fly/dns-checker/fly.toml
fi 
cd $FILE_PATH

