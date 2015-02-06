FROM phusion/baseimage:0.9.16
MAINTAINER Konstantin Krauss <konstantin.krauss@me.com>

CMD ["/sbin/my_init"]

ADD . /kk_build

RUN chmod +x /kk_build/install.sh && \
    /kk_build/install.sh && \
    rm -rf /kk_build

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV ES_HEAP_SIZE 1g

ENV START elasticsearch,logstash,kibana

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/data"]

EXPOSE 9200
EXPOSE 5000
EXPOSE 5601
