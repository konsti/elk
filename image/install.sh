#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt-get update -qq

# Cleanup phusion/passenger-ruby image
rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh
apt-get --purge remove openssh-server -y
apt-get autoremove -y
rm -rf /var/run/sshd
rm -f /etc/insecure_key
rm -f /etc/insecure_key.pub
rm -f /usr/sbin/enable_insecure_key

apt-get dist-upgrade -y --no-install-recommends

# Create /data dir
mkdir /data

# Install JAVA

echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
add-apt-repository -y ppa:webupd8team/java
apt-get update
apt-get install -y oracle-java8-installer
rm -rf /var/lib/apt/lists/*
rm -rf /var/cache/oracle-jdk8-installer


# Install Logstash

LOGSTASH_SHA=d59ef579c7614c5df9bd69cfdce20ed371f728ff

curl -SL "https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz" -o logstash.tar.gz

DOWNLOADED_SHA=$(openssl sha1 logstash.tar.gz)

if [ "SHA1(logstash.tar.gz)= ${LOGSTASH_SHA}" = "${DOWNLOADED_SHA}" ]; then
  tar -xf logstash.tar.gz -C /usr/local
  mv /usr/local/logstash-1.4.2 /usr/local/logstash
  mv /kk_build/config_files/logstash.conf /etc/logstash.conf
  rm logstash.tar.gz
else
  echo "Logstash Key is _not_ valid!!!";
  exit 1
fi

# Install ElasticSearch

ELASTICSEARCH_SHA=ae381615ec7f657e2a08f1d91758714f13d11693

curl -SL "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.2.tar.gz" -o elasticsearch.tar.gz

DOWNLOADED_SHA=$(openssl sha1 elasticsearch.tar.gz)

if [ "SHA1(elasticsearch.tar.gz)= ${ELASTICSEARCH_SHA}" = "${DOWNLOADED_SHA}" ]; then
  tar -xf elasticsearch.tar.gz -C /usr/local
  mv /usr/local/elasticsearch-1.4.2 /usr/local/elasticsearch
  mkdir -p /etc/elasticsearch
  mv /kk_build/config_files/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
  mv /kk_build/config_files/logging.yml /etc/elasticsearch/logging.yml
  rm elasticsearch.tar.gz

  # Install Kopf Plugin
  /usr/local/elasticsearch/bin/plugin --install lmenezes/elasticsearch-kopf/1.4.4
else
  echo "ElasticSearch Key is _not_ valid!!!";
  exit 1
fi

# Install Kibana

curl -SL "https://download.elasticsearch.org/kibana/kibana/kibana-4.0.0-beta3.tar.gz" -o kibana.tar.gz
tar -xf kibana.tar.gz -C /usr/local
mv /usr/local/kibana-4.0.0-beta3 /usr/local/kibana
mv /kk_build/config_files/kibana.yml /usr/local/kibana/config/kibana.yml
rm kibana.tar.gz

# Move startup scripts
mkdir -p /etc/my_init.d
mv /kk_build/10_system_env.sh /etc/my_init.d
mv /kk_build/90_start_services.sh /etc/my_init.d
chmod +x /etc/my_init.d/*

# Make env sourcing possible
chmod 755 /etc/container_environment
chmod 644 /etc/container_environment.sh /etc/container_environment.json
echo "source /etc/container_environment.sh" > /etc/bash.bashrc
