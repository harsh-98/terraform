#/bin/bash

set -e 

FLY_APP=deviator
LOCAL_FOLDER=deviator
FILE_PATH=$(realpath `dirname $0`)
cd $FILE_PATH/../../../$LOCAL_FOLDER
#
fly deploy  --build-target app --dockerfile Dockerfile.flyio  --config ../terraform/fly/$FLY_APP/fly.toml
cd $FILE_PATH

