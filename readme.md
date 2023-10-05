# Terraform for gearbox deployment

## Creating copy of db:

`sudo systemctl stop charts_server.service `
`sudo systemctl stop third-eye`

`sudo su postgres`
`psql`
> In psql shell:

```
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'gearbox'
AND pid != pg_backend_pid();

CREATE DATABASE gearbox_copy
WITH TEMPLATE gearbox
OWNER db_digger;
```

> Exit psql shell and run in bash:

`sudo systemctl start third-eye`
`sudo systemctl start charts_server`