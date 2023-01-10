#!/bin/bash

apt-get install logstash

cat << EOF > /etc/logstash/conf.d/auth-log.conf
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
  elasticsearch { hosts => ["localhost:9200"] }
  stdout { codec => rubydebug }
}
EOF

chmod 644 /var/log/auth.log
systemctl start logstash.service
