#/bin/bash

set -e 

FLY_APP=definder
FILE_PATH=$(realpath `dirname $0`)

IMAGE=`fly image show | ggrep  -oP "\K(deployment-\w+)"`
IMAGE="registry.fly.io/"$FLY_APP":"$IMAGE

cd $FILE_PATH/../../../$FLY_APP
#
VERSION=`go list  -m -u  github.com/Gearbox-protocol/go-liquidator  | awk '{print $2}'`
go get github.com/Gearbox-protocol/go-liquidator@$VERSION
mkdir -p dist
sudo rm -rf dist/go-liquidator
cp -r "$GOPATH/pkg/mod/github.com/!gearbox-protocol/go-liquidator@$VERSION" ./dist/go-liquidator
#

if [ "remote" = "$1" ]; then
    fly deploy  --build-target app --dockerfile docker/Dockerfile.flyio  --config ../terraform/fly/$FLY_APP/fly.toml
elif [ "image" =  "$1" ];then
    fly deploy  --image $IMAGE  --config ../terraform/fly/$FLY_APP/fly.toml
fi 
cd $FILE_PATH

