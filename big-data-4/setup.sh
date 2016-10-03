#!/bin/bash

# upgrade spark python to work with python 3
sudo yum upgrade -y spark-python

# update spark log4j to be quiet and restart
sudo cp setup/log4j.properties /usr/lib/spark/conf/
sudo chmod 644 /usr/lib/spark/conf/log4j.properties
sudo service spark-master restart
sudo service spark-worker restart

# decompress csv files
gzip -d *.csv.gz

# download and install anaconda for pandas, jupyter
wget http://repo.continuum.io/archive/Anaconda3-4.0.0-Linux-x86_64.sh
bash Anaconda3-4.0.0-Linux-x86_64.sh

# set environment variables to load spark libs in jupyter
echo "export PYSPARK_DRIVER_PYTHON_OPTS=\"notebook\"" >> ~/.bashrc
echo "export PYSPARK_DRIVER_PYTHON=jupyter"  >> ~/.bashrc

echo "Run 'source .bashrc' to complete the setup."
