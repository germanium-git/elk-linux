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

# create a prometheus user & group
groupadd --system prometheus
useradd -s /sbin/nologin --system -g prometheus prometheus

chown -R prometheus:prometheus /etc/prometheus/ /var/lib/prometheus/
chmod -R 775 /etc/prometheus/ /var/lib/prometheus/


cat << EOF > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Restart=always
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file=/etc/prometheus/prometheus.yml \
    --storage.tsdb.path=/var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries \
    --web.listen-address=0.0.0.0:9090

[Install]
WantedBy=multi-user.target
EOF


chmod -R 775 /etc/prometheus/ /var/lib/prometheus/

systemctl start prometheus
sudo systemctl enable prometheus


pubip=$(curl --silent ifconfig.me)
echo "Try to access Prometheus on http://$pubip:5601"