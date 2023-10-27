# Migrating from linode

- Create new server
- set anvil_server_ip
- run the commands in module/server/main.tf
- login as debian
- run `zsh ./config/scripts/psql.sh ${var.database} ${var.db_username} ${var.db_password}`
- install nginx and conf from `config/nginx` 
```
sudo apt-get install -y nginx
sudo cp -r ~/config/nginx/testnet.gearbox.foundation.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/testnet.gearbox.foundation.conf /etc/nginx/sites-enabled/ -f
sudo systemctl restart nginx
```
- copy envs from envs/goerli to `envs/anvil` that all servers have there `.env.application` file
- `./scripts/deploy.sh anvil third-eye` # it applies the migration
- `sudo apt-get install jq`
- ssh-keygen # and pub key installation in mainnet server #TOREMOVE
- new server pg_hba.conf add  `debian local auth as peer` and `debian host auth as md5`.
```
local   all     debian                                     peer
host   all     debian                                   127.0.0.1/32  trust
host   all     debian                   49.36.219.53/16 md5
```
- Add create/delete db permission to user `ALTER USER debian CREATEDB`
- copy db from mainnet for testing
```
bash -x /home/debian/third-eye/db_scripts/local_testing/local_test.sh "139.177.179.137" "" "debian" # debian is superuser , and empty is proxy server, not needed
```

### Deploy services
```
./scripts/deploy.sh anvil anvil-third-eye
./scripts/deploy.sh anvil charts_server
./scripts/deploy.sh anvil gpointbot
# copy the local.db , referral_rows table in the gpointbot sqlite db.
./scripts/deploy.sh anvil gearbox-ws
./scripts/deploy.sh anvil telebot
./scripts/deploy.sh anvil app_status
./scripts/deploy.sh anvil webhook
./scripts/deploy.sh anvil anvil-mainnet-third-eye
```

### Enabling ssh and full strict mode in cloudflare
- Ask konstantin to generate cert/priv key for testnet.gearbox.foundation.
- https://developers.cloudflare.com/ssl/origin-configuration/origin-ca for understanding cloudflare origin CA and how to install in [nginx](https://www.digicert.com/kb/csr-ssl-installation/nginx-openssl.htm).
```
ssl    on;
ssl_certificate    /etc/ssl/your_domain_name.pem; (or bundle.crt)
ssl_certificate_key    /etc/ssl/your_domain_name.key;

server_name your.domain.com;
access_log /var/log/nginx/nginx.vhost.access.log;
error_log /var/log/nginx/nginx.vhost.error.log;
```
- check the certificate
``` # for checking certificate
openssl x509 -text -noout -in  cert
```


#### Commands for disabling service check in app_status
```
app_status_add () {
  curl "http://$ip:10000/dontCheck/update?network=$1&application=$2&operation=remove"
}
app_status_remove () {
  curl "http://$ip:10000/dontCheck/update?network=$1&application=$2&operation=add"
}

# http://139.177.179.137:10000/dontCheck/get

--
app_status_add mainnet definder
app_status_remove mainnet definde
```


# Migrating charts-server
charts-server is used, at charts , landing page and by defillama for circulation supply. Noted will keep in mind to notify in future.


##
```
sudo apt-get install bun
curl -fsSL https://bun.sh/install | bash
npm i -g pm2
pm2 start main.ts

```