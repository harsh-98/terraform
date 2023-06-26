#/bin/bash

set -e 

FLY_APP=gearbox-ws
LOCAL_FOLDER=go-liquidator
FILE_PATH=$(realpath `dirname $0`)
cd $FILE_PATH/../../../$LOCAL_FOLDER
#
fly deploy  --build-target app --dockerfile docker/Dockerfile.flyio.$FLY_APP  --config ../terraform/fly/$FLY_APP/fly.toml
cd $FILE_PATH

