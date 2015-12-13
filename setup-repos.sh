#!/bin/bash
#before running this script, register and attach subscription
subscription-manager repos --disable="*"
subscription-manager repos \
    --enable="rhel-7-server-rpms" \
    --enable="rhel-7-server-extras-rpms" \
    --enable="rhel-7-server-optional-rpms" \
    --enable="rhel-7-server-satellite-tools-6.1-rpms" \
    --enable="rhel-7-server-ose-3.1-rpms"
