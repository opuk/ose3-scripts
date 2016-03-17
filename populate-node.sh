#!/bin/bash

docker pull registry.access.redhat.com/openshift3/ose-haproxy-router
docker pull registry.access.redhat.com/openshift3/ose-deployer
docker pull registry.access.redhat.com/openshift3/ose-sti-builder
docker pull registry.access.redhat.com/openshift3/ose-docker-builder
docker pull registry.access.redhat.com/openshift3/ose-pod
docker pull registry.access.redhat.com/openshift3/ose-docker-registry

docker pull registry.access.redhat.com/openshift3/logging-deployment
docker pull registry.access.redhat.com/openshift3/logging-elasticsearch
docker pull registry.access.redhat.com/openshift3/logging-kibana
docker pull registry.access.redhat.com/openshift3/logging-fluentd
docker pull registry.access.redhat.com/openshift3/logging-auth-proxy
docker pull registry.access.redhat.com/openshift3/metrics-deployer
docker pull registry.access.redhat.com/openshift3/metrics-hawkular-metrics
docker pull registry.access.redhat.com/openshift3/metrics-cassandra
docker pull registry.access.redhat.com/openshift3/metrics-heapster

# docker pull registry.access.redhat.com/jboss-amq-6/amq-openshift
# docker pull registry.access.redhat.com/jboss-eap-6/eap-openshift
# docker pull registry.access.redhat.com/jboss-webserver-3/tomcat7-openshift
docker pull registry.access.redhat.com/jboss-webserver-3/tomcat8-openshift
# docker pull registry.access.redhat.com/rhscl/mongodb-26-rhel7
# docker pull registry.access.redhat.com/rhscl/mysql-56-rhel7
# docker pull registry.access.redhat.com/rhscl/perl-520-rhel7
docker pull registry.access.redhat.com/rhscl/php-56-rhel7
docker pull registry.access.redhat.com/rhscl/postgresql-94-rhel7
# docker pull registry.access.redhat.com/rhscl/python-27-rhel7
docker pull registry.access.redhat.com/rhscl/python-34-rhel7
# docker pull registry.access.redhat.com/rhscl/ruby-22-rhel7
docker pull registry.access.redhat.com/openshift3/nodejs-010-rhel7
