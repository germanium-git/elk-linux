#!/bin/bash

file='/etc/elasticsearch/elasticsearch.yml'

# Uncomment http.port: 9200
pattern1=http.port; sed -i "/$pattern1/s/^#//g" $file

# Change  network.host: localhost to network.host: 0.0.0.0
sed -i '/network.host:/c\network.host: 0.0.0.0' $file

# Check and append discovery.type: single-node
pattern2=discovery.type
if grep -q $pattern2 $file
then
  echo 'discovery.type found; re-set to single-node'
  sed -i '/discovery.type/c\discovery.type: single-node' $file
else
  echo 'discovery.type not found; appending at the end of file'
  echo 'discovery.type: single-node' >> $file
fi

# Start elasticsearch service
echo 'Starting elasticsearch service'
systemctl start elasticsearch.service

echo 'Check if elasticsearch is running by curl http://localhost:9200'
