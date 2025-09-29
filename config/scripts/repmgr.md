# Setup

## primary 144.91.114.166
- install repmgr and postgresql
- create ssh key for postgres user and add to standby
- create /etc/repmgr.conf and primary 
- (for this u need to update postgresql.conf for supporting replication and pg_hba.conf for accepting connections from primary and standby repmgr.)

## standby 37.60.225.176
- install repmgr and postgresql
- create ssh key for postgres user and add to primary
- create /etc/repmgr.conf and connect with standby postgres database


### connecting  the servers
> creates backup of repmgr db on the standby. this will be updated in the standby db, when the repmgr standby register is done. and new data directory will be used in standby as repmgr connection also cloned to . /var/lib/postgresql/16/data
```
repmgr -h PRIMARY_IP -U repmgr -d repmgr -f /etc/repmgr.conf standby clone --copy-external-config-files --dry-run
repmgr -h PRIMARY_IP -U repmgr -d repmgr -f /etc/repmgr.conf standby clone --copy-external-config-files 
```



Notes
- linux postgres password was created to add ssh keys from standby to primary and via.
- postgres user password was changed for?
- repmgr should be run as postgres user as it users ssh.


## primary as standby after failover
as postgres user --
on old primary to join again.
- stop `repmgrd -f /etc/repmgr.conf -d`
- ps aux |grep repmgr | cut -d ' ' -f 3 | xargs  sudo kill -9
- ps aux |grep repmgr
- sudo systemctl stop postgresql
<!-- - sudo rm -rf /var/lib/postgresql/16/data -->
```
PRIMARY_IP=144.91.114.166
repmgr -h $PRIMARY_IP -U repmgr -d repmgr -f /etc/repmgr.conf standby clone --copy-external-config-files --dry-run
repmgr -h $PRIMARY_IP -U repmgr -d repmgr -f /etc/repmgr.conf standby clone --copy-external-config-files -F --verbose # force
<!-- repmgr -h $PRIMARY_IP -U repmgr -d repmgr -f /etc/repmgr.conf node rejoin  --verbose -->
<!-- repmgr -h $PRIMARY_IP -U repmgr -d repmgr -f /etc/repmgr.conf standby clone  -F  --rsync-only   # force -->
<!-- repmgr primary unregister -f /etc/repmgr.conf --node-id=2 -f --> On the field note to re-register in case like is `in active primary and running as standby. `
--
```
- in the postgresql.conf , change the datafile from if /main to /data.
- sudo systemctl start postgresql
- repmgr -f /etc/repmgr.conf  standby register --force
- start `repmgrd -f /etc/repmgr.conf -d` # for logs
- repmgr -f /etc/repmgr.conf cluster show
# fly 
- https://community.fly.io/t/heres-how-to-fix-an-unreachable-2-zombie-1-replica-ha-postgres-cluster/19503
- https://www.linode.com/docs/guides/manage-replication-failover-on-postgresql-cluster-using-repmgr/#how-to-configure-ssh
- pgx driver in gorm. https://pkg.go.dev/github.com/jackc/pgx/v5@v5.3.1/pgconn#ParseConfig
- https://github.com/jackc/pgx/discussions/1608
- the wal_keep_segments parameter in PostgreSQL has been renamed to wal_keep_size. Specifies the minimum number of past log file segments kept in the pg_xlog directory. The wal_keep_segments parameter in PostgreSQL controls the minimum number of past WAL (Write-Ahead Log) file segments kept on the primary server for standby servers
- https://stackoverflow.com/questions/28162021/setting-wal-keep-segments-for-postgresql-hot-standby, "FATAL:  could not receive data from WAL stream: ERROR:  requested WAL segment  has already been removed". 
- https://github.com/EnterpriseDB/repmgr/issues/659, service postgresql process.
- https://www.postgresql.org/docs/current/runtime-config-replication.html and wal_keep_size and max_replication_slots 10 for replicas and max_wal_senders 10 server sender processes.

# stopping previous service
```
network=arbitrum,optimism
sudo systemctl  disable $network-charts_server.service
sudo systemctl  disable $network-third-eye.service
sudo systemctl  disable $network-gearbox-ws.service
sudo systemctl  stop $network-charts_server.service
sudo systemctl  stop $network-third-eye.service
sudo systemctl  stop $network-gearbox-ws.service
```