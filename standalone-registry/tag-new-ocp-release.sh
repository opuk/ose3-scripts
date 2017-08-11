#!/bin/bash

if [ $# -eq 0 ]; then
echo "Provide version tag."
echo "For example: $0 v3.5.5.33"
exit 1
fi

images=( registry.access.redhat.com/openshift3/ose-haproxy-router \
         registry.access.redhat.com/openshift3/ose-deployer \
         registry.access.redhat.com/openshift3/ose-recycler \
         registry.access.redhat.com/openshift3/ose-sti-builder \
         registry.access.redhat.com/openshift3/ose-docker-builder \
         registry.access.redhat.com/openshift3/ose-pod \
         registry.access.redhat.com/openshift3/ose-docker-registry \
         registry.access.redhat.com/openshift3/node \
         registry.access.redhat.com/openshift3/openvswitch \
         registry.access.redhat.com/openshift3/ose )

for i in ${images[@]}; do
  is=$(echo $i | awk -F/ '{ print $3 }')
  oc tag $i:$1 $is:$1
done

echo "Don't forget registry console: oc tag registry.access.redhat.com/openshift3/registry-console:3.5 registry-console:3.5"
