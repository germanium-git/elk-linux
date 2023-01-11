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

mv /etc/systemd/system/prometheus.service /etc/systemd/system/prometheus.service.backup

cat << EOF > /etc/systemd/system/prometheus.service
# my global config                                                                                                                                                                                                                [12/846]
global:
  scrape_interval: 15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets:
          # - alertmanager:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: "prometheus"

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ["localhost:9090"]
  - job_name: "elasticsearch"
    scrape_interval: 60s
    scrape_timeout:  30s
    metrics_path: "/metrics"
    static_configs:
    - targets: ["10.0.1.5:9114"]
      labels:
        service: elasticsearch
    relabel_configs:
    - source_labels: [__address__]
      regex: '(.*)\:9108'
      target_label:  'instance'
      replacement:   '$1'
    - source_labels: [__address__]
      regex:         '.*\.(.*)\.lan.*'
      target_label:  'environment'
      replacement:   '$1'

  - job_name: node
    static_configs:
    - targets: ["10.0.1.5:9100"]


remote_write:
- url: "https://prometheus-blocks-prod-us-central1.grafana.net/api/prom/push"
  basic_auth:
    username: "169071"
    password: "eyJrIjo......................................1MTIxfQ=="

EOF

systemctl start prometheus
sudo systemctl enable prometheus


pubip=$(curl --silent ifconfig.me)
echo -e "Try to access Prometheus on http://$pubip:5601"

echo -e "\nUpdate the password for remote_write: and restart the service"