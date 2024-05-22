#/bin/sh

apt-get update
apt-get -y git gcc  zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed  's/exec zsh -l//g')"
#install go
VERSION=1.18.6
wget https://dl.google.com/go/go$VERSION.linux-amd64.tar.gz

sudo tar -C /usr/local -xzf go$VERSION.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/.local/bin:$HOME/go/bin' >> ~/.zshrc
echo 'export GOPATH=$HOME/go'>> ~/.zshrc
sudo ln -s /usr/local/go/bin/go /usr/bin/go
source ~/.zshrc
mkdir -p ~/go


# build
cd /root/dns-checker; go build cmd/whois_server/main.go

# whois proxy

cat > /etc/systemd/system/whois_proxy.service <<EOF 
[Unit]
Description="Whois proxy"

[Service]
User=root
WorkingDirectory=/root/dns-checker
ExecStart=/root/dns-checker/main
Restart=always
RestartSec=3 

[Install]
WantedBy=multi-user.target
EOF

systemctl restart whois_proxy.service 
systemctl status whois_proxy.service 