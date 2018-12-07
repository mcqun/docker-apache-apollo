FROM java:8-alpine

LABEL maintainer="Mcqun <mchqun@126.com>" version="1.0"

RUN set -ex \
	&& sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/' /etc/apk/repositories \
	&& apk update \
    && apk add --no-cache curl

ENV APACHE_APOLLO_VERSION 1.7.1
ENV APACHE_APOLLO_HOME    /opt/apache-apollo

ARG add_user=apollo

# Install Apache Apollo

WORKDIR /tmp

RUN curl -s -o apache-apollo.tar.gz \
		http://mirror.bit.edu.cn/apache/activemq/activemq-apollo/$APACHE_APOLLO_VERSION/apache-apollo-$APACHE_APOLLO_VERSION-unix-distro.tar.gz \
    && mkdir -p $APACHE_APOLLO_HOME \
    && tar -xf apache-apollo.tar.gz\
    && ls \
    && mv -f ./apache-apollo-$APACHE_APOLLO_VERSION/* $APACHE_APOLLO_HOME\
    && rm apache-apollo.tar.gz 

# Clean up

RUN rm -rf /var/cache/apk/* /tmp/*

# Creating a Broker Instance

WORKDIR /var/lib

RUN $APACHE_APOLLO_HOME/bin/apollo create broker

COPY apollo.xml /var/lib/broker/etc

EXPOSE 61680
EXPOSE 61681
EXPOSE 61613
EXPOSE 61614
EXPOSE 61623
EXPOSE 61624

ENTRYPOINT ["/var/lib/broker/bin/apollo-broker", "run"]