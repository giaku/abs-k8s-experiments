#!/bin/bash
ns=$1

if [$1 -e ""]
then
  printf "Error delete evicted, missing namespace..."
  exit 1
fi

evicting=$(kubectl get pods -n $ns | grep Evicted | awk '{print $1;}')
if test -z "$evicting"
then
  echo "nothing evicted"
else
  kubectl delete pods -n $ns $(kubectl get pods -n $ns | grep Evicted | awk '{print $1;}')
fi
