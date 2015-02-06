#!/bin/bash

# Install services

## Elasticsearch

mkdir /etc/service/elasticsearch
touch /etc/service/elasticsearch/down
cat > /etc/service/elasticsearch/run <<EOF
#!/bin/bash
/usr/local/elasticsearch/bin/elasticsearch "" "" "-Des.default.config=/etc/elasticsearch/elasticsearch.yml -Des.default.path.data=/data -Des.default.path.conf=/etc/elasticsearch"
EOF
chmod +x /etc/service/elasticsearch/run

## Logstash

mkdir /etc/service/logstash
touch /etc/service/logstash/down
cat > /etc/service/logstash/run <<EOF
#!/bin/bash
/usr/local/logstash/bin/logstash -f /etc/logstash.conf
EOF
chmod +x /etc/service/logstash/run

## Kibana

mkdir /etc/service/kibana
touch /etc/service/kibana/down
cat > /etc/service/kibana/run <<EOF
#!/bin/bash
/usr/local/kibana/bin/kibana
EOF
chmod +x /etc/service/kibana/run
