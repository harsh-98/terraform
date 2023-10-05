#!/usr/bin/zsh

GH_TOKEN=$1
REPO_NAME=$2
ORG_NAME=$3

#
if [ "$ORG_NAME" = "" ]; then 
    REPO_ORG_NAME="Gearbox-protocol/$REPO_NAME.git"
else
    REPO_ORG_NAME="${ORG_NAME}/${REPO_NAME}.git"
fi 

#
if [ "$GH_TOKEN" = "NO_TOKEN" ] ; then 
    REPO_URL="git@github.com:${REPO_ORG_NAME}"
else 
    REPO_URL="https://oauth:$GH_TOKEN@github.com/${REPO_ORG_NAME}"
fi

#
if [ ! -e $REPO_NAME ] ; then
    git clone $REPO_URL
    cd $REPO_NAME
    git remote remove origin
else 
    cd $REPO_NAME
    git remote add origin $REPO_URL
    git pull origin `git branch --show-current`:`git branch --show-current` -f
    git remote remove origin
fi
#
