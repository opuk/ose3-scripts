#!/bin/bash

UPSTREAM_REGISTRY=registry.access.redhat.com
REGISTRY=registry.example.com:5000

upstream_repos=( openshift3/ose-deployer openshift3/ose-docker-registry openshift3/ose-pod openshift3/ose-docker-builder openshift3/ose-sti-builder openshift3/ose-haproxy-router openshift3/mongodb-24-rhel7 openshift3/mysql-55-rhel7 openshift3/nodejs-010-rhel7 openshift3/perl-516-rhel7 openshift3/php-55-rhel7 openshift3/postgresql-92-rhel7 openshift3/python-33-rhel7 openshift3/ruby-20-rhel7 openshift3/logging-deployment openshift3/logging-elasticsearch openshift3/logging-kibana openshift3/logging-fluentd openshift3/logging-auth-proxy openshift3/metrics-deployer openshift3/metrics-hawkular-metrics openshift3/metrics-cassandra openshift3/metrics-heapster openshift3/jenkins-1-rhel7 openshift3/image-inspector openshift3/ose-recycler )
#upstream_repos=( openshift3/ose-deployer openshift3/ose-docker-registry openshift3/ose-pod openshift3/ose-docker-builder openshift3/ose-sti-builder openshift3/ose-haproxy-router )

#xpaas_repos=( jboss-amq-6/amq-openshift jboss-eap-6/eap-openshift jboss-webserver-3/tomcat7-openshift jboss-webserver-3/tomcat8-openshift )

for i in ${upstream_repos[@]}; do
  docker pull -a $UPSTREAM_REGISTRY/$i
done

for IMAGE in $(docker images |grep $UPSTREAM_REGISTRY|awk '{print $1}'|sort -u) 
do
  echo $IMAGE
  NEW_IMAGE=$(echo ${IMAGE}|sed "s/$UPSTREAM_REGISTRY/$REGISTRY/")

  for IMAGE_TAG in $(docker images | grep $IMAGE |awk '{print $2}'|sort -u)
  do
    echo $IMAGE_TAG
    docker tag ${IMAGE}:${IMAGE_TAG} ${NEW_IMAGE}:${IMAGE_TAG}
    docker push ${NEW_IMAGE}:${IMAGE_TAG}
  done
done
