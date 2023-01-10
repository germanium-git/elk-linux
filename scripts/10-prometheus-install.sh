#!/bin/bash

apt-get update && apt-get upgrade -y

# Create the configuration directory
mkdir -p /etc/prometheus
mkdir -p /var/lib/prometheus

# Download & extract the installation file
wget https://github.com/prometheus/prometheus/releases/download/v2.41.0/prometheus-2.41.0.linux-amd64.tar.gz
tar -xvf prometheus-2.41.0.linux-amd64.tar.gz

# Copy the binary file & move console files in console directory and library files in the console_libraries  directory to /etc/prometheus/ directory.
cd prometheus-2.41.0.linux-amd64
mv prometheus promtool /usr/local/bin/
mv consoles/ console_libraries/ /etc/prometheus/

# Move the prometheus.yml template configuration file to the  /etc/prometheus/ directory.
mv prometheus.yml /etc/prometheus/prometheus.yml
