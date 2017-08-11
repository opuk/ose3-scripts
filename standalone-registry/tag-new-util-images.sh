#!/bin/bash

if [ $# -eq 0 ]; then
echo "Provide version tag."
echo "For example: $0 3.5.0"
exit 1
fi

images=( registry.access.redhat.com/openshift3/logging-elasticsearch \
         registry.access.redhat.com/openshift3/logging-kibana \
         registry.access.redhat.com/openshift3/logging-fluentd \
         registry.access.redhat.com/openshift3/logging-curator \
         registry.access.redhat.com/openshift3/logging-auth-proxy \
         registry.access.redhat.com/openshift3/metrics-deployer \
         registry.access.redhat.com/openshift3/metrics-hawkular-metrics \
         registry.access.redhat.com/openshift3/metrics-cassandra \
         registry.access.redhat.com/openshift3/metrics-heapster  )

for i in ${images[@]}; do
  is=$(echo $i | awk -F/ '{ print $3 }')
  oc tag $i:$1 $is:$1 --scheduled
done

         
