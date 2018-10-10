#!/bin/sh

OSE_VERS=3.11
REG_VERS=2
UPSTREAM=registry.access.redhat.com
REGISTRY=registry.example.com:5000
# https://bugzilla.redhat.com/show_bug.cgi?id=1481130
USE_SKOPEO=yes
SKOPEO_DEST_VERIFY=false

# Add/remove XXX to variable names to disable/enable syncing of the images

ose_images="
  openshift3/apb-base
  openshift3/apb-tools
  openshift3/automation-broker-apb
  openshift3/csi-attacher
  openshift3/csi-driver-registrar
  openshift3/csi-livenessprobe
  openshift3/csi-provisioner
  openshift3/grafana
  openshift3/image-inspector
  openshift3/mariadb-apb
  openshift3/mediawiki
  openshift3/mediawiki-apb
  openshift3/mysql-apb
  openshift3/ose-ansible
  openshift3/ose-ansible-service-broker
  openshift3/ose-cli
  openshift3/ose-cluster-autoscaler
  openshift3/ose-cluster-capacity
  openshift3/ose-cluster-monitoring-operator
  openshift3/ose-console
  openshift3/ose-configmap-reloader
  openshift3/ose-control-plane
  openshift3/ose-deployer
  openshift3/ose-descheduler
  openshift3/ose-docker-builder
  openshift3/ose-docker-registry
  openshift3/ose-efs-provisioner
  openshift3/ose-egress-dns-proxy
  openshift3/ose-egress-http-proxy
  openshift3/ose-egress-router
  openshift3/ose-haproxy-router
  openshift3/ose-hyperkube
  openshift3/ose-hypershift
  openshift3/ose-keepalived-ipfailover
  openshift3/ose-kube-rbac-proxy
  openshift3/ose-kube-state-metrics
  openshift3/ose-metrics-server
  openshift3/ose-node
  openshift3/ose-node-problem-detector
  openshift3/ose-operator-lifecycle-manager
  openshift3/ose-pod
  openshift3/ose-prometheus-config-reloader
  openshift3/ose-prometheus-operator
  openshift3/ose-recycler
  openshift3/ose-service-catalog
  openshift3/ose-template-service-broker
  openshift3/ose-web-console
  openshift3/postgresql-apb
  openshift3/registry-console
  openshift3/snapshot-controller
  openshift3/snapshot-provisioner
  rhel7/etcd
"

ose_images_cont="
  openshift3/metrics-cassandra
  openshift3/metrics-hawkular-metrics
  openshift3/metrics-hawkular-openshift-agent
  openshift3/metrics-heapster
  openshift3/oauth-proxy
  openshift3/ose-logging-curator5
  openshift3/ose-logging-elasticsearch5
  openshift3/ose-logging-eventrouter
  openshift3/ose-logging-fluentd
  openshift3/ose-logging-kibana5
  openshift3/ose-metrics-schema-installer
  openshift3/prometheus
  openshift3/prometheus-alert-buffer
  openshift3/prometheus-alertmanager
  openshift3/prometheus-node-exporter
  rhgs3/rhgs-server-rhel7
  rhgs3/rhgs-volmanager-rhel7
  rhgs3/rhgs-gluster-block-prov-rhel7
  rhgs3/rhgs-s3-server-rhel7
"


xpaas_images="
  redhat-openjdk-18/openjdk18-openshift
  jboss-webserver-3/webserver30-tomcat8-openshift
  jboss-eap-7/eap70-openshift
  redhat-sso-7/sso70-openshift
  rhscl/postgresql-95-rhel7
  rhscl/nodejs-6-rhel7
"

jenkins_images="
  openshift3/jenkins-2-rhel7
  openshift3/jenkins-slave-base-rhel7
  openshift3/jenkins-slave-maven-rhel7
  openshift3/jenkins-slave-nodejs-rhel7
"

gluster_images="
  rhgs3/rhgs-volmanager-rhel7
  rhgs3/rhgs-server-rhel7
  rhgs3/rhgs-gluster-block-prov-rhel7
  rhgs3/rhgs-s3-server-rhel7
"

# Configure Docker if needed
[ "$USE_SKOPEO" != "yes" ] && (rpm -q docker > /dev/null 2>&1 || yum install -y docker)
if [ "$USE_SKOPEO" != "yes" ] && ! grep -q "add-registry $REGISTRY" /etc/sysconfig/docker; then
  systemctl stop docker
  sed -i -e 's,--log-driver=,--log-level=warn --log-driver=,' /etc/sysconfig/docker
  sed -i -e 's,--log-level=,--max-concurrent-downloads=10 --log-level=,' /etc/sysconfig/docker
  sed -i -e 's,--log-level=,--max-concurrent-uploads=10 --log-level=,' /etc/sysconfig/docker
  sed -i -e 's,^ADD_REGISTRY=,#ADD_REGISTRY=,' /etc/sysconfig/docker
  sed -i -e 's,^BLOCKED_REGISTRY=,#BLOCKED_REGISTRY=,' /etc/sysconfig/docker
  sed -i -e 's,^INSECURE_REGISTRY=,#INSECURE_REGISTRY=,' /etc/sysconfig/docker
  cat <<EOF>> /etc/sysconfig/docker
ADD_REGISTRY='--add-registry $REGISTRY --add-registry $UPSTREAM'
BLOCK_REGISTRY='--block-registry all'
EOF
  if [ $REG_VERS -eq 1 ]; then
    echo INSECURE_REGISTRY=\'--insecure-registry $REGISTRY\' >> /etc/sysconfig/docker
  fi
  systemctl enable docker
fi
[ "$USE_SKOPEO" != "yes" ] && systemctl start docker

# Pull/copy
for img in $ose_images $ose_images_cont $ose_images_opt; do
  avail="$(curl -s https://$UPSTREAM/v1/repositories/$img/tags | grep -Po '"v?'${OSE_VERS/\./\\.}'.*?"' | tr -d '"' | sort -V)"
  # rhel7/etcd has its own versioning
  if [ "$img" = "rhel7/etcd" ]; then
    [ "$USE_SKOPEO" != "yes" ] && docker pull $UPSTREAM/$img
    [ "$USE_SKOPEO"  = "yes" ] && echo Copying $img... && skopeo copy --dest-tls-verify=$SKOPEO_DEST_VERIFY --dest-cert-dir=/etc/docker-distribution/registry docker://$UPSTREAM/$img docker://$REGISTRY/$img
  fi
  [ -n "$avail" ] || continue
  # Get latest images with and without v in the tag / patch level
  tags=""
  tags="$tags $(printf %s\\n $avail | grep v${OSE_VERS}$)"
  tags="$tags $(printf %s\\n $avail | grep ^v | tail -n 1)"
  tags="$tags $(printf %s\\n $avail | grep -v ^v | tail -n 1)"
  tags="$tags $(printf %s\\n $avail | grep ^v | grep -v -- - | tail -n 1)"
  tags="$tags $(printf %s\\n $avail | grep -v ^v | grep -v -- - | tail -n 1)"
  tags="$(echo $tags | tr ' ' '\n' | sort -u)"
  for tag in $tags; do
    if [ "$USE_SKOPEO" != "yes" ]; then
      docker pull $UPSTREAM/$img:$tag || exit 1
    else
      echo Copying $img:$tag...
      skopeo copy --dest-tls-verify=$SKOPEO_DEST_VERIFY --dest-cert-dir=/etc/docker-distribution/registry docker://$UPSTREAM/$img:$tag docker://$REGISTRY/$img:$tag || exit 1
    fi
  done
done

for img in $xpaas_images $jenkins_images $gluster_images; do
  # Latest only
  if [ "$USE_SKOPEO" != "yes" ]; then
    docker pull $UPSTREAM/$img || exit 2
  else
    echo Copying $img...
    skopeo copy --dest-tls-verify=$SKOPEO_DEST_VERIFY --dest-cert-dir=/etc/docker-distribution/registry docker://$UPSTREAM/$img docker://$REGISTRY/$img || exit 2
  fi
done

# Push
if [ "$USE_SKOPEO" != "yes" ]; then
  images="$(docker images)"
  for img in $ose_images $ose_images_cont $ose_images_opt $xpaas_images $jenkins_images $gluster_images; do
    for tag in $(printf %s\\n "$images" | awk '/'$UPSTREAM\\/${img/\//\\/}' / {print $2}'); do
      [ "$tag" = "<none>" ] && continue
      docker tag $UPSTREAM/$img:$tag $REGISTRY/$img:$tag || exit 3
      docker push $REGISTRY/$img:$tag || exit 4
      docker rmi $REGISTRY/$img:$tag || exit 5
    done
  done
fi

# Garbage collect
/usr/bin/registry garbage-collect /etc/docker-distribution/registry/config.yml

