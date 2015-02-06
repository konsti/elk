# Basis image for running ELK in a docker container

* based on phusion/baseimage (sshd removed)
* oracle JRE 8
* elasticsearch 1.4.2
* logstash 1.4.2
* kibana

### Start apps in the container

By default all apps are managed by the baseimage runit supervisor. All services are marked as `down`.

The `down` file get's removed on system startup by the `90_start_services.sh` if the name of the service is mentioned in the `ENV START` variable.

e.g. You can start only elasticsearch by setting `ENV START elasticsearch` in your Dockerfile or `--env START` variable.

### Config Files

__Please extend this image for your own config files__

List of config files:

* `image/config_files/elasticsearch.yml` __->__ `/etc/elasticsearch/elasticsearch.yml`
* `image/config_files/logging.yml` __->__ `/etc/elasticsearch/logging.yml`
* `image/config_files/logstash.conf` __->__ `/etc/logstash.conf`
* `image/config_files/kibana.yml` __->__ `/usr/local/kibana/config/kibana.yml`

Some configurations (especially Elasticsearch) are made with environment variables. Check the Dockerfile for override possibilities.

__Make sure to at least set your ES_HEAP_SIZE to half your RAM and not more than 32g__
http://www.elasticsearch.org/guide/en/elasticsearch/guide/current/heap-sizing.html

### Volumes

There is a `/data` volume to persist the Elasticsearch db.
