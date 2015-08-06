#!/bin/bash
#before running this script, register and attach subscription
subscription-manager repos --disable="*"
subscription-manager repos \
    --enable="rhel-7-server-rpms" \
    --enable="rhel-7-server-extras-rpms" \
    --enable="rhel-7-server-optional-rpms" \
    --enable="rhel-7-server-ose-3.0-rpms"
yum remove NetworkManager -y
yum install wget git net-tools bind-utils iptables-services bridge-utils -y
#quick install only?
yum install gcc python-virtualenv -y
yum update -y
yum install docker -y
sed -i "s/OPTIONS.*/OPTIONS='--selinux-enabled --insecure-registry 172.30.0.0\/0'/" /etc/sysconfig/docker

