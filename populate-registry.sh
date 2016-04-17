#!/bin/bash

UPSTREAM_REGISTRY=registry.access.redhat.com
REGISTRY=registry.example.com:5000

upstream_repos=( openshift3/ose-deployer openshift3/ose-docker-registry openshift3/ose-pod openshift3/ose-docker-builder openshift3/ose-sti-builder openshift3/ose-haproxy-router openshift3/mongodb-24-rhel7 openshift3/mysql-55-rhel7 openshift3/nodejs-010-rhel7 openshift3/perl-516-rhel7 openshift3/php-55-rhel7 openshift3/postgresql-92-rhel7 openshift3/python-33-rhel7 openshift3/ruby-20-rhel7 )

#xpaas_repos=( jboss-amq-6/amq-openshift jboss-eap-6/eap-openshift jboss-webserver-3/tomcat7-openshift jboss-webserver-3/tomcat8-openshift )

for i in ${upstream_repos[@]}; do
  docker pull $UPSTREAM_REGISTRY/$i
done

for i in ${upstream_repos[@]}; do
  docker tag $UPSTREAM_REGISTRY/$i $REGISTRY/$i
done

for i in ${upstream_repos[@]}; do
  docker push $REGISTRY/$i
done


