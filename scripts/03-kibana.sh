#!/bin/bash
apt-get install kibana

file='/etc/kibana/kibana.yml'

# Allow access to Kibana from anywhere; change network.host: localhost to network.host: 0.0.0.0
sed -i '/server.host:/c\server.host: "0.0.0.0"' $file

# Configure Kibana to use the elasticsearch from the localhost
sed -i '/elasticsearch.hosts:/c\elasticsearch.hosts: ["http://localhost:9200"]' $file

systemctl start kibana
