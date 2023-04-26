#!/bin/sh

GH_TOKEN=$1
REPO=$2
ASSET_ID=`curl -H "Authorization: token $GH_TOKEN" https://api.github.com/repos/$REPO/releases | jq  '.[0].assets | map(select(.name | contains("linux_amd64") ))[0].id'`
curl -OL -H "Authorization: token $GH_TOKEN"  -H "Accept: application/octet-stream"   https://api.github.com/repos/$REPO/releases/assets/$ASSET_ID
tar -xf $ASSET_ID
