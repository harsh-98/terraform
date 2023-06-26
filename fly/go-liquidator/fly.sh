#/bin/bash

set -e 

FLY_APP=go-liquidator
FILE_PATH=$(realpath `dirname $0`)
cd $FILE_PATH/../../../$FLY_APP
#
fly deploy  --build-target app --dockerfile docker/Dockerfile.flyio.$FLY_APP  --config ../terraform/fly/$FLY_APP/fly.toml
cd $FILE_PATH


