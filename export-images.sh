#!/bin/bash

docker save -o ose3-images.tar \
    registry.access.redhat.com/openshift3/ose-haproxy-router \
    registry.access.redhat.com/openshift3/ose-deployer \
    registry.access.redhat.com/openshift3/ose-sti-builder \
    registry.access.redhat.com/openshift3/ose-docker-builder \
    registry.access.redhat.com/openshift3/ose-pod \
    registry.access.redhat.com/openshift3/ose-docker-registry

docker save -o ose3-logging-metrics-images.tar \
    registry.access.redhat.com/openshift3/logging-deployment \
    registry.access.redhat.com/openshift3/logging-elasticsearch \
    registry.access.redhat.com/openshift3/logging-kibana \
    registry.access.redhat.com/openshift3/logging-fluentd \
    registry.access.redhat.com/openshift3/logging-auth-proxy \
    registry.access.redhat.com/openshift3/metrics-deployer \
    registry.access.redhat.com/openshift3/metrics-hawkular-metrics \
    registry.access.redhat.com/openshift3/metrics-cassandra \
    registry.access.redhat.com/openshift3/metrics-heapster

docker save -o ose3-builder-images.tar \
    registry.access.redhat.com/jboss-amq-6/amq-openshift \
    registry.access.redhat.com/jboss-eap-6/eap-openshift \
    registry.access.redhat.com/jboss-webserver-3/tomcat7-openshift \
    registry.access.redhat.com/jboss-webserver-3/tomcat8-openshift \
    registry.access.redhat.com/rhscl/mongodb-26-rhel7 \
    registry.access.redhat.com/rhscl/mysql-56-rhel7 \
    registry.access.redhat.com/rhscl/perl-520-rhel7 \
    registry.access.redhat.com/rhscl/php-56-rhel7 \
    registry.access.redhat.com/rhscl/postgresql-94-rhel7 \
    registry.access.redhat.com/rhscl/python-27-rhel7 \
    registry.access.redhat.com/rhscl/python-34-rhel7 \
    registry.access.redhat.com/rhscl/ruby-22-rhel7 \
    registry.access.redhat.com/openshift3/nodejs-010-rhel7


