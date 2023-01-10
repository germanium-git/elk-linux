#!/bin/bash

apt-get install logstash

# Configure two logstash pipelines

mv /etc/logstash/pipelines.yml  /etc/logstash/pipelines.yml.backup

cat << EOF > /etc/logstash/pipelines.yml
- pipeline.id: srx
  path.config: "/etc/logstash/conf.d/srx.conf"
- pipeline.id: auth
  path.config: "/etc/logstash/conf.d/auth.conf"
EOF

# Configure auth pipeline

cat << EOF > /etc/logstash/conf.d/auth.conf
input {
  file {
    path => "/var/log/auth.log"
  }
}

filter {

  if [message] =~ "sshd" {
    mutate {
      add_tag => "SSHD"
    }
  }

  if [message] =~ "sshd" and [message] =~ "closed" {
    grok {
      match => { "message" => "%{SYSLOGTIMESTAMP:syslog_timestamp} %{HOSTNAME:hostname} %{WORD:process}\[%{WORD:pid}\]: %{DATA:conn_message} %{USER:user} %{IP:ip} port %{WORD:port}" }
    }
  }

  if [message] =~ "sshd" and [message] =~ "Accepted"  {
    grok {
      match => { "message" => "%{SYSLOGTIMESTAMP:syslog_timestamp} %{HOSTNAME:hostname} %{WORD:process}\[%{WORD:pid}\]: %{DATA:con_message} for %{WORD:user} from %{IP:ip} port %{WORD:port}" }
    }
  }

  if [message] =~ "sshd" and [message] =~ "unix" {
    grok {
      match => { "message" => "%{SYSLOGTIMESTAMP:syslog_timestamp} %{HOSTNAME:hostname} %{WORD:process}\[%{WORD:pid}\]: %{DATA:con_message} for user %{USER:user}" }
    }
  }
}

output {
  elasticsearch { 
    hosts => ["localhost:9200"] 
    index => "auth-%{+YYYY.MM.dd}"
    }
  stdout { codec => rubydebug }
}
EOF

# Make the log file accessible for logstash
chmod 644 /var/log/auth.log


# Configure the 2nd pipeline to read SRX syslog

cat << EOF > /etc/logstash/conf.d/srx.conf
input {
    udp {
        port => 5000
        type => "syslog"
    }
}

filter {
  if [message] =~ "RT_FLOW" {
    mutate {
      add_tag => "FLOW"
    }
  }
}

output {
  elasticsearch {
    hosts => ["localhost:9200"]
    index => "srx-%{+YYYY.MM.dd}"
    }
  stdout { codec => rubydebug }
}
EOF


# Start logstash service

systemctl start logstash.service
