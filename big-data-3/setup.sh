#!/bin/bash


sudo yum install -y postgresql-server

sudo service postgresql initb
sudo service postgresql start
sudo -u postgres psql -c "CREATE USER cloudera"
sudo -u postgres -c "ALTER USER cloudera with superuser"
sudo -u postgres createdb cloudera
cd postgres
psql -f init-postgres.sql
cd ..
