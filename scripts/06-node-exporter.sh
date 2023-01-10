#!/bin/bash

wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
tar xvfz node_exporter-1.5.0.linux-amd64.tar.gz

cd node_exporter-1.5.0.linux-amd64/
chmod +x node_exporter
cp node_exporter /usr/local/bin/node_exporter

cat << EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Prometheus node exporter

[Service]
User=root
ExecStart=/usr/local/bin/node_exporter
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start node_exporter.service
systemctl enable node_exporter.service
