#!/usr/bin/zsh
VERSION=$1
wget https://dl.google.com/go/go$VERSION.linux-amd64.tar.gz

sudo tar -C /usr/local -xzf go$VERSION.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/.local/bin:$HOME/go/bin' >> ~/.zshrc
echo 'export GOPATH=$HOME/go'>> ~/.zshrc
source ~/.zshrc
mkdir -p ~/go





