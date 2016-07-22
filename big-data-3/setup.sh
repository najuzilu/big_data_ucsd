#!/bin/bash


# install postgres server
sudo yum install -y postgresql-server postgresql-jdbc

# upgrade spark python to work with python 3
sudo yum upgrade -y spark-python

# create initial database
sudo service postgresql initdb

# setup authentication
echo "host    cloudera    cloudera     127.0.0.1/32   trust" > /tmp/pg
sudo cat /var/lib/pgsql/data/pg_hba.conf >> /tmp/pg
sudo cp /var/lib/pgsql/data/pg_hba.conf /var/lib/pgsql/data/pg_hba.conf.DIST
sudo mv /tmp/pg /var/lib/pgsql/data/pg_hba.conf

# start postgres server during boot
sudo chkconfig --level 345 postgresql on

# start postgres server
sudo service postgresql start

# create postgres account for cloudera user
sudo -u postgres psql -c "CREATE USER cloudera"

# make cloudera account admin
sudo -u postgres psql -c "ALTER USER cloudera with superuser"

# create default db for cloudera account
sudo -u postgres createdb cloudera

# create and load tables for hands on
psql -f init-postgres.sql

# download and install anaconda for pandas, jupyter
wget http://repo.continuum.io/archive/Anaconda3-4.0.0-Linux-x86_64.sh
bash Anaconda3-4.0.0-Linux-x86_64.sh

# add postgres jdbc jar to spark classpath
echo "export SPARK_CLASSPATH=/usr/share/java/postgresql-jdbc-8.4.704.jar" >> ~/.bashrc

# set environment variables to load spark libs in jupyter
echo "export PYSPARK_DRIVER_PYTHON_OPTS=\"notebook\"" >> ~/.bashrc
echo "export PYSPARK_DRIVER_PYTHON=jupyter"  >> ~/.bashrc
