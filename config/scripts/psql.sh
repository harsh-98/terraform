sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
#sudo apt-get install postgresql # older version
sudo apt-get install -y postgresql # version 12 

## in psql shell

DB=$1
USERNAME=$2
PASSWORD=$3
sudo su postgres
psql -c 'create database gearbox'
psql -c  "create user $USERNAME with encrypted password '""${PASSWORD}""'"
psql -c "grant all privileges on database $DB to $USERNAME"

HBA_FILE=`psql -t -P format=unaligned -c 'SHOW hba_file;'`
sed "s|local   all             all                                     peer|local   all     $USERNAME                                     md5|g"  $HBA_FILE
exit
sudo systemctl restart postgresql


# ALTER USER user_name WITH PASSWORD 'new_password';
# for error: invalid command \N
# https://stackoverflow.com/questions/20427689/psql-invalid-command-n-while-restore-sql/42161524#:~:text=Postgres%20uses%20%22%5CN%22%20as,message%20is%20a%20false%20alarm.
#psql -v ON_ERROR_STOP=1