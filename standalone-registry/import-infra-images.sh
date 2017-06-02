#!/bin/bash

images=( registry.access.redhat.com/rhel7/etcd \
         registry.access.redhat.com/rhscl/httpd-24-rhel7 \
         registry.access.redhat.com/openshift3/jenkins-2-rhel7 \
         registry.access.redhat.com/openshift3/logging-auth-proxy \
         registry.access.redhat.com/openshift3/logging-curator \
         registry.access.redhat.com/openshift3/logging-elasticsearch \
         registry.access.redhat.com/openshift3/logging-fluentd \
         registry.access.redhat.com/openshift3/logging-kibana \
         registry.access.redhat.com/openshift3/metrics-cassandra \
         registry.access.redhat.com/openshift3/metrics-hawkular-metrics \
         registry.access.redhat.com/openshift3/metrics-heapster \
         registry.access.redhat.com/openshift3/node \
         registry.access.redhat.com/openshift3/openvswitch \
         registry.access.redhat.com/openshift3/ose \
         registry.access.redhat.com/openshift3/ose-deployer \
         registry.access.redhat.com/openshift3/ose-docker-builder \
         registry.access.redhat.com/openshift3/ose-docker-registry \
         registry.access.redhat.com/openshift3/ose-haproxy-router \
         registry.access.redhat.com/openshift3/ose-keepalived-ipfailover \
         registry.access.redhat.com/openshift3/ose-pod \
         registry.access.redhat.com/openshift3/ose-sti-builder \
         registry.access.redhat.com/openshift3/registry-console \
         registry.access.redhat.com/openshift3/image-inspector )

for i in ${images[@]}; do
  oc import-image $i --all --confirm
done

         
