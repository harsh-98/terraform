# ssh print data from the files
fly ssh console -C 'cat data/returned_accounts.json'

# checking volumes for application
fly volumes list # shows id of attahed vm
fly scale show
# creating volume
>>NOTE https://fly.io/docs/apps/volume-storage/
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
flyctl ssh issue --agent
cd the application
fly proxy 10022:22
scp -P 10022 root@localhost:/app/activities.db .
scp -P 10022 root@localhost:/app/db/referral.db .

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

## Misc

-- on concurrency: https://community.fly.io/t/problem-increasing-apps-connections-hard-limit/13913/3
[http_service.concurrency]
    hard_limit = 10000
    soft_limit = 7500
    type = "connections"

-- https://fly.io/docs/reference/configuration/
-- https://fly.io/docs/reference/services/
-- https://fly.io/docs/reference/private-networking/#flycast-private-load-balancing

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

## scale individual machines
```
fly machine update 185e643f535628 --vm-memory 2048
https://fly.io/docs/postgres/managing/scaling/
``` 
