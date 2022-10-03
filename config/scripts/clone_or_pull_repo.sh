
GH_TOKEN=$1
REPO_NAME=$2
if [ "$GH_TOKEN" = "NO_TOKEN" ] ; then 
    REPO="git@github.com:Gearbox-protocol/$REPO_NAME.git"
else 
    REPO="https://oauth:$GH_TOKEN@github.com/Gearbox-protocol/$REPO_NAME.git"
fi

if [ ! -e $REPO_NAME ] ; then
    git clone $REPO < y
    cd liquidator; git remote remove origin
else 
    cd liquidator
    git remote add origin $REPO
    git pull origin master
    git remote remove origin
fi
#
