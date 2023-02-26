#!/bin/sh

DB=$1
DB_USERNAME=$2
ANS=$(sudo su postgres -c "psql -At -d template1 -c \"SELECT 1 FROM pg_database WHERE datname='"${DB}"'\" ")
if [ "$ANS" -ne 1 ]; then
    sudo su  postgres -c "psql -At -d template1 -c 'CREATE DATABASE "${DB}" WITH OWNER "${DB_USERNAME}"'"
fi