#!/bin/bash
# ElasticSearch Exporter
# https://bidhankhatri.com.np/elk/monitoring-elasticsearch-cluster/#systemd-service

wget https://github.com/prometheus-community/elasticsearch_exporter/releases/download/v1.5.0/elasticsearch_exporter-1.5.0.linux-amd64.tar.gz
tar xvf elasticsearch_exporter-1.5.0.linux-amd64.tar.gz
cd elasticsearch_exporter-1.5.0.linux-amd64/
cp elasticsearch_exporter /usr/local/bin/es_exporter


cat << EOF > /etc/systemd/system/es_exporter.service
[Unit]
Description=Prometheus ES_exporter
After=local-fs.target network-online.target network.target
Wants=local-fs.target network-online.target network.target

[Service]
User=root
Nice=10
ExecStart = /usr/local/bin/es_exporter --es.uri=http://localhost:9200 --es.all --es.indices --es.timeout 20s
ExecStop= /usr/bin/killall es_exporter

[Install]
WantedBy=default.target
EOF

systemctl daemon-reload
systemctl start es_exporter.service
systemctl enable es_exporter.service
