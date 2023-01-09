#!/bin/bash
apt-get update
apt-get upgrade -y
sudo apt-get install default-jre -y

# Download and install the Public Signing Key:
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

# Install the apt-transport-https package on Debian before proceeding
apt-get install apt-transport-https

# Save the repository definition
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list

apt-get update && sudo apt-get install elasticsearch

# Running Elasticsearch with systemd
systemctl daemon-reload
systemctl enable elasticsearch.service
