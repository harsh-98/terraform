sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
#sudo apt-get install postgresql # older version
sudo apt-get install -y postgresql # version 12 

## in psql shell

DB=$1
DB_USERNAME=$2
DB_PASSWORD=$3
# sudo su - postgres <<EOF 
# psql -c 'create database $DB'
# psql -c  "create user $DB_USERNAME with encrypted password '""${DB_PASSWORD}""'"
# psql -c "grant all privileges on database $DB to $DB_USERNAME"
# EOF

# pg_database_owner in psql 15 so only owner has create rights
# so other user will not have the permission to create objects i.e. tables in that schema.
# therefore the previous create db and grant permission as two steps will not work.
sudo su - postgres <<EOF 
psql -c  "create user $DB_USERNAME with encrypted password '""${DB_PASSWORD}""'"
psql -c 'create database $DB with owner $DB_USERNAME'
EOF



HBA_FILE=`sudo su - postgres -c "psql -t -P format=unaligned -c 'SHOW hba_file;'"`
sudo sed -i "s|local   all             all                                     peer|local   all     $DB_USERNAME                                     md5|g"  $HBA_FILE
CONFIG_FILE=`sudo su - postgres -c "psql -t -P format=unaligned -c 'SHOW config_file;'"`
sudo sed -i "s|#listen_addresses = 'localhost'|listen_addresses = '0.0.0.0'|g"  $CONFIG_FILE
sudo systemctl restart postgresql


# ALTER USER user_name WITH PASSWORD 'new_password';
# for error: invalid command \N
# https://stackoverflow.com/questions/20427689/psql-invalid-command-n-while-restore-sql/42161524#:~:text=Postgres%20uses%20%22%5CN%22%20as,message%20is%20a%20false%20alarm.
#psql -v ON_ERROR_STOP=1



