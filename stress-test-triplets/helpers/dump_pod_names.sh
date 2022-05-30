#!/bin/bash

filename=$2
filepath=$1
ns=$3
echo "Pod names $2 attack available in file $filepath/$filename"
kubectl get pods -n $3 -o wide | grep Running | awk '{print $1}' | sort > $filepath/$filename
