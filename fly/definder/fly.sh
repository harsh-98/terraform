#/bin/bash

set -e 

FLY_APP=definder
FILE_PATH=$(realpath `dirname $0`)
cd $FILE_PATH/../../../$FLY_APP
#
VERSION=`go list  -m -u  github.com/Gearbox-protocol/go-liquidator  | awk '{print $2}'`
go get github.com/Gearbox-protocol/go-liquidator@$VERSION
mkdir -p dist
sudo rm -rf dist/go-liquidator
cp -r "$GOPATH/pkg/mod/github.com/!gearbox-protocol/go-liquidator@$VERSION" ./dist/go-liquidator
#
fly deploy  --build-target app --dockerfile docker/Dockerfile.flyio  --config ../terraform/fly/$FLY_APP/fly.toml
cd $FILE_PATH

