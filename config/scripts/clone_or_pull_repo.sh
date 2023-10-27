#!/usr/bin/zsh

GH_TOKEN=$1
REPO_NAME=$2
EXTRA=$3

ORG_NAME=`echo $EXTRA | cut -d "/" -f 1`
NETWORK=`echo $EXTRA | cut -d "/" -f 2`


FOLDER_NAME="$NETWORK-$REPO_NAME"

if [ "$NETWORK" = "" ]; then
    exit 1
fi

if [ "$ORG_NAME" = "" ]; then 
    REPO_URL="Gearbox-protocol/$REPO_NAME.git"
else
    REPO_URL="${ORG_NAME}/${REPO_NAME}.git"
fi 

#
if [ "$GH_TOKEN" = "NO_TOKEN" ] ; then 
    REPO_URL="git@github.com:${REPO_URL}"
else 
    REPO_URL="https://oauth:$GH_TOKEN@github.com/${REPO_URL}"
fi

if [ ! -e $FOLDER_NAME ] ; then
    git clone $REPO_URL  $FOLDER_NAME
    cd $FOLDER_NAME
    git remote remove origin
else 
    cd $FOLDER_NAME
    git remote add origin $REPO_URL
    git pull origin `git branch --show-current`:`git branch --show-current` -f
    git remote remove origin
fi
