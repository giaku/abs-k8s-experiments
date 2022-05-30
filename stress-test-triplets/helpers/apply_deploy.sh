#!/bin/bash

#$1 is the namespace
#$2 is the deployment filepath in the master node

ns=$1
deploy=$2

if [ -z "$1" ]
then
  printf "Error deleting deployment, missing namespace..."
  exit 1
fi

if [ -z "$2" ]
then
  printf "Error delete evicted, missing deployment filepath..."
  exit 1
fi

kubectl apply -n $ns -f $deploy
