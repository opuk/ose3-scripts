# usage

TBD

# Various notes

## ipfailover notes

Basic setup of ipfailover pods.

```bash
oc project default

#oc create serviceaccount ipfailover

oc adm policy add-scc-to-user privileged -z ipfailover

IPRANGE="172.16.3.10-12"
IMAGE="registry.example.com:5000/openshift3/ose-keepalived-ipfailover:v3.11"

oc adm ipfailover --replicas=3 --virtual-ips="$IPRANGE" --selector="node-role.kubernetes.io/infra=true" --images=$IMAGE

```

## issue IDM certificates

Example on how to issue certificates to an enrolled server. In this case the ansible control node.

```bash
SERVER=openshift.example.com

ipa service-add HTTP/$SERVER
ipa host-add $SERVER
ipa service-add-host --hosts $(hostname -f) HTTP/$SERVER
ipa cert-request --principal=HTTP/$SERVER

ipa-getcert request -k /etc/pki/tls/private/$SERVER.key -f /etc/pki/tls/certs/$SERVER.crt -r -N CN=$SERVER -D $SERVER -K HTTP/$SERVER


```
