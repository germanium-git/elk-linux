# ELK-linux
Demonstration of ELK stack on a Linux system
The repository contains code to install the components of the ELK stack version 7.x shown below to the Ubuntu 20.04.5 LTS server.
* elasticsearch
* kibana
* logstash

Besides the ELK it also provides with instructions on how to implemnet a monitoring solution by using Prometheus.

## Installation
### ELK stack
#### Elasticsearch
Run the script 01-elk-setup.sh to get elastiksearch installed.
```bash
sudo sh 01-elk-setup.sh
```

Update the the elastiksearch configuration file */etc/elasticsearch/elasticsearch.yml* by executing the script 02-elk-yml.sh.
```bash
sudo sh 02-elk-yml.sh
```

Check if elasticsearch listens on the port 9200.
```bash
curl http://<localhost or the private ip>:9200 
```

Check which ports the server is listenimg on
```bash
sudo ss -tulwn | grep LISTEN
```

Check the elasticsearch service.
```bash
sudo systemctl status elasticsearch.service
```
Check the elasticsearch service

```bash
sudo tail -f /var/log/elasticsearch/elasticsearch.log
```


#### Kibana
Run the script 03-kibana.sh to get Kibana installed and to update the configuration file */etc/kibana/kibana.yml*.
```bash
sudo sh 03-kibana.sh
```

Check logs:
```bash
sudo tail -f /var/log/kibana/kibana.log
```

Check the kibana service.
```bash
sudo systemctl status kibana.service
```

Open kibana UI in the browser
http://\<*public ip*>:5601

#### Logstash

sudo systemctl status logstash.service

create index pattern
Discovery 

### Prometheus

10-prometheus-install.sh

Check the version
```bash
prometheus --version
promtool --version
```

#### ELK exporter

Check if the service node_exporter is running
```bash
sudo systemctl status es_exporter.service
```

Check what metrics are scraped
```bash
curl http://localhost:9114/metrics
```

#### Linux node exporter

https://prometheus.io/docs/guides/node-exporter/

Check if the service node_exporter is running
```bash
sudo systemctl status node_exporter.service
```

Check what metrics are scraped
```bash
curl http://localhost:9100/metrics
```

#### Grafana
