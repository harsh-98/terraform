# Enabling https

Download certbot:
```
sudo apt install snapd
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
```

Install the https certificates and update the nginx website config:
```
sudo certbot --nginx -d arbitrum.gearbox.foundation
```
