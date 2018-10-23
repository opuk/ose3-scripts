#!/bin/bash

mkdir /srv/nexus-data && chown -R 200 /srv/nexus-data

podman run -d -p 5000:5000 -p 8081:8081 --name nexus -v /srv/nexus-data:/nexus-data:Z docker.io/sonatype/nexus3

