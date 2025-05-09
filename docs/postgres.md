# Terminate connection to db
```
SELECT * FROM pg_stat_activity WHERE datname = '?';

SELECT 
    pg_terminate_backend(pid) 
FROM 
    pg_stat_activity 
WHERE 
    pid <> pg_backend_pid()
    AND datname = '?';
```

# db size 
```
SELECT pg_size_pretty( pg_database_size('?') );
```

# Zombie lock on fly
```
fly machines list # to get the checks on 
fly status # to check the primary pg db.
fly checks list
```
# Promote replica to primary since the primary has zombie.lock and delete primary server
- https://community.fly.io/t/heres-how-to-fix-an-unreachable-2-zombie-1-replica-ha-postgres-cluster/19503
After this all the dbs are set to readonly transaction state. 
```
show default_transaction_read_only;
set default_transaction_read_only = off;
alter database <yourDB> set default_transaction_read_only = off;
```

# create read only user
Connect with user who is superuser or user with grantable privileges.
```
 create user readonly_user with encrypted password 'readonly_password';
<!-- Connect to the database in which table exists. [Most Important] -->
 GRANT CONNECT ON DATABASE gearbox TO readonly_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly_user;
<!-- revoke SELECT ON ALL TABLES IN SCHEMA public from readonly_user; -->

Then, run the following command : GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO developer;

```
-- https://tableplus.com/blog/2018/04/postgresql-how-to-grant-access-to-users.html