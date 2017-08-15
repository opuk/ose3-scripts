#!/bin/bash

if ! [ -x "/usr/bin/skopeo" ]; then
  echo 'Error: skopeo is not installed. It is available in rhel-7-server-extras-rpms.'
  exit 1
fi

OSE_VERS=3.6
UPSTREAM_REGISTRY=registry.access.redhat.com
REGISTRY=docker-distribution.example.com:5000

DEST_REGISTRY_SECURE=false

ose_images="
  openshift3/ose-deployer
  openshift3/ose-docker-builder
  openshift3/ose-docker-registry
  openshift3/ose-haproxy-router
  openshift3/ose-pod
  openshift3/ose-sti-builder
  openshift3/registry-console
  openshift3/logging-auth-proxy
  openshift3/logging-curator
  openshift3/logging-elasticsearch
  openshift3/logging-fluentd
  openshift3/logging-kibana
  openshift3/metrics-cassandra
  openshift3/metrics-hawkular-metrics
  openshift3/metrics-heapster
"

ose_images_cont="
  rhel7/cockpit
  rhel7/etcd
  openshift3/ose
  openshift3/node
  openshift3/openvswitch
"

ose_images_opt="
  openshift3/ose-egress-router
  openshift3/ose-keepalived-ipfailover
  openshift3/ose-recycler
  openshift3/image-inspector
"

xpaas_images="
  redhat-openjdk-18/openjdk18-openshift
  jboss-webserver-3/webserver30-tomcat8-openshift
  jboss-eap-7/eap70-openshift
  redhat-sso-7/sso70-openshift
  rhscl/postgresql-95-rhel7
  rhscl/nodejs-4-rhel7
"

jenkins_images="
  openshift3/jenkins-2-rhel7
  openshift3/jenkins-slave-base-rhel7
  openshift3/jenkins-slave-maven-rhel7
  openshift3/jenkins-slave-nodejs-rhel7
"

# Pull
for img in $ose_images $ose_images_cont; do
  avail="$(curl -s https://$UPSTREAM_REGISTRY/v1/repositories/$img/tags | grep -Po '"v?'${OSE_VERS/\./\\.}'.*?"' | tr -d '"' | sort -V)"
  # rhel7/etcd has its own versioning
  [ "$img" = "rhel7/etcd" ] && skopeo copy --dest-tls-verify=$DEST_REGISTRY_SECURE docker://$UPSTREAM_REGISTRY/$img docker://$REGISTRY/$img
  [ -n "$avail" ] || continue
  # Get latest images with and without v in the tag / patch level
  tags=""
  tags="$tags $(printf %s\\n $avail | grep v${OSE_VERS}$)"
  tags="$tags $(printf %s\\n $avail | grep ^v | tail -n 1)"
  tags="$tags $(printf %s\\n $avail | grep -v ^v | tail -n 1)"
  tags="$tags $(printf %s\\n $avail | grep ^v | grep -v -- - | tail -n 1)"
  tags="$tags $(printf %s\\n $avail | grep -v ^v | grep -v -- - | tail -n 1)"
  tags="$(echo $tags | tr ' ' '\n' | sort -u)"
  echo -n "Tags to sync: "
  echo $tags
  for tag in $tags; do
    echo "Syncing $img:$tag"
    skopeo copy --dest-tls-verify=$DEST_REGISTRY_SECURE docker://$UPSTREAM_REGISTRY/$img:$tag docker://$REGISTRY/$img:$tag
  done
done

exit 0

for img in $xpaas_images $jenkins_images; do
  # Latest only
  skopeo copy --dest-tls-verify=$DEST_REGISTRY_SECURE docker://$UPSTREAM_REGISTRY/$img docker://$REGISTRY/$img
done
