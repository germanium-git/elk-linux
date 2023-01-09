#!/bin/bash

cat << EOF > /etc/logstash/conf.d/srx.conf
input {
 syslog {
 port => 5000
 type => "syslog"
 }
}

filter {

if [type] == "syslog" {

if [message] =~ "RT_FLOW_SESSION_CREATE" {
 mutate {
 add_tag => "FLOWCREATE"
 }
}
if [message] =~ "RT_FLOW_SESSION_DENY" {
 mutate {
 add_tag => "FLOWDENY"
 }
}

if "FLOWCREATE" in [tags] {
 grok {
 match => [ "message", ".*session created %{IP:src_addr}/%{DATA:src_port}->%{IP:dst_addr}/%{DATA:dst_port} %{DATA:service} %{IP:nat_src_ip}/%{DATA:nat_src_port}->%{IP:nat_dst_ip}/%{DATA:nat_dst_port} %{DATA:src_nat_rule_name} %{DATA:d
st_nat_rule_name} %{INT:protocol_id} %{DATA:policy_name} %{DATA:from_zone} %{DATA:to_zone} %{INT:session_id} .*" ]
 }
}

if "FLOWDENY" in [tags] {
 grok {
 match => [ "message", ".*session denied %{IP:src_addr}/%{DATA:src_port}->%{IP:dst_addr}/%{DATA:dst_port} %{DATA:service} %{INT:protocol_id}\(\d\) %{DATA:policy_name} %{DATA:from_zone} %{DATA:to_zone} .*" ]
 }
}

}
}

output {

#stdout { codec => rubydebug }

if [type] == "syslog" {
 elasticsearch {
 hosts => ["localhost:9200"]
 index => "srx-%{+YYYY.MM.dd}"}
 }
}
EOF
