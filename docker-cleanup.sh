#!/bin/bash

for i in $(docker ps -qa); do docker rm $i; done

for i in $(docker images -qa); do docker rmi $i; done
