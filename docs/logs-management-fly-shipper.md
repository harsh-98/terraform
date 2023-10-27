# Exporting logs from fly to server

## Supported vectors
- Honeycomb https://github.com/superfly/fly-log-shipper#provider-configuration
Previously was using honeycomb as vector for log shipper to send the logs to honeycomb.

## Other env variables
- ACCESS_TOKEN=`fly auth token`, QUEUE(if multiple instances of logger), SUBJECT

### Reference
- https://fly.io/docs/going-to-production/monitoring/exporting-logs/

### Sample vector file:
```
https://github.com/superfly/fly-log-shipper/blob/3b780b3a3c68fdbbbb55430d7d9ff1eb377fdbf0/vector-configs/vector.toml
```

### Nats
- NATS http: https://github.com/superfly/fly-log-shipper?tab=readme-ov-file#http
- https://github.com/nats-io/nats-server/tree/main/util service systemd file
Install https://docs.nats.io/running-a-nats-service/introduction/installation
```
go install github.com/nats-io/nats-server/v2@latest
```