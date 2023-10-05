# ssh print data from the files
fly ssh console -C 'cat data/returned_accounts.json'

# checking volumes for application
fly volumes list # shows id of attahed vm
fly scale show
# creating volume
fly volumes create definder -s 1

# deploy future apps on v2
fly orgs apps-v2 default-on personal
fly migrate-to-v2

# fly configs
fly config env

# docker image build locally
fly deploy  --local-only --image definder:latest --build-target app --dockerfile docker/Dockerfile.flyio  --config ../terraform/fly/definder/fly.toml
flyctl auth docker
# fly check docker image
fly image show


# copy files from volume
flyctl ssh issue -d agent
fly proxy 10022:22
scp -P 10022 root@localhost:/app/activities.db .

# fly scale to more compute 
fly scale vm shared-cpu-1x
# 

# fly ctl daemon
fly agent stop
LOG_LEVEL=debug fly agent daemon-start

## Mount volume to macheine 
```yaml
[mounts]
  source = "myapp_data"
  destination = "/data"
  processes= ["disk"] 
  ```


## v1
```
fly scale count 1
fly vm status
fly machines list #doens't work for v1
fly suspend #only for v1
fly resume #only for v1
fly status # checking the status of the current application
fly apps list# for checking the status of all applications
```