#!/bin/bash

#$1 is the namespace
#$2 is the deployment name in k8s

ns=$1
deploy=$2

if [ -z "$1" ]
then
  printf "Error deleting deployment, missing namespace..."
  exit 1
fi

if [ -z "$2" ]
then
  printf "Error delete evicted, missing deployment name..."
  exit 1
fi

ssh root@master kubectl delete deploy -n $ns $deploy
