#!/usr/bin/python

import sys

#scheduler
import sched, time

#prometheus client
from prometheus_api_client.utils import parse_datetime
from datetime import datetime
from prometheus_api_client import PrometheusConnect

s = sched.scheduler(time.time, time.sleep)

#times in seconds
initial_wait = int(sys.argv[1]) #200
interval = int(sys.argv[2]) #15
wave_duration = int(sys.argv[3]) #530
pathp = sys.argv[4]
pathn = sys.argv[5]

# CHANGE WITH PROMETHEUS URL
PROMETHEUS = "http://10.101.120.229:9090/"

def replace_node_name(old_name):
  node_dict={
    "IP:9100" : "vegeta",
    "IP:9100" : "worker3",
    "IP:9100" : "master",
    "IP:9100" : "worker4",
    "IP:9100" : "worker2",
    "IP:9100" : "worker1",
    "IP:9100" : "system-worker1",
    "IP:9100" : "system-worker2"}
  # return node_dict[old_name]
  return old_name

def fetch_nodes_metrics(sc,start,nf_name,data):
  if(time.time()-start < wave_duration):
    print("Fetching nodes metrics...")
    print("Average load on nodes in the last 1 minute (list of one value per node and current timestamps):")
    rs = prom.custom_query('100-(avg by (instance)(rate(node_cpu_seconds_total{job="node-exporter", mode="idle"}[1m]))*100)')
    nodes = {}
    for item in rs:
      name = replace_node_name(item["metric"]["instance"])
      print(name, item["value"][0], item["value"][1])
      nodes[name] = {}
      nodes[name]["timestamp"] = item["value"][0]
      nodes[name]["value"] = item["value"][1]
    print()
    ## try create file and write headers, except append to nodes file
    try:
      nodes_file = open(nf_name, "x")
      data = nodes
      nodes_file.write("\"Time\"")
      for k in nodes.keys():
        nodes_file.write(",\""+k+"\"")
      nodes_file.write("\n")
    except FileExistsError:
      nodes_file = open(nf_name, "a")
      for k in nodes.keys():
        data[k] = nodes[k]
    nodes_file.write(str(data[list(data.keys())[0]]["timestamp"]))
    for item in data.keys():
      nodes_file.write(","+data[item]["value"])
    nodes_file.write("\n")
    s.enter(interval, 2, fetch_nodes_metrics, (sc,start,nf_name,data))

def fetch_pods_metrics(sc,start,pf_name,data):
  if(time.time()-start < wave_duration):
    print("Fetching pods metrics...")
    print("Consumptions of all pods in md2 instant (list of value for each pod):")
    rs = prom.custom_query('label_replace(sum(node_namespace_pod_container:container_cpu_usage_seconds_total:sum_rate{namespace="md2"} * on(namespace,pod) group_left(workload, workload_type) namespace_workload_pod:kube_pod_owner:relabel{namespace="md2", workload_type="deployment"}) by (pod,node,workload), "sname", "$1", "workload", "(.*)-w.*")')
    pods = {}
    for item in rs:
      name = item["metric"]["pod"]
      print(name, item["value"][0], item["value"][1])
      pods[name] = {}
      pods[name]["timestamp"] = item["value"][0]
      pods[name]["value"] = item["value"][1]
      pods[name]["header"] = "\"pod:"+name+"_service:"+item["metric"]["sname"]+"_node:"+item["metric"]["node"]+"\""
    print()

    try:
      pods_file = open(pf_name, "x")
      data = pods
      pods_file.write("\"Time\"")
      for k in pods.keys():
        pods_file.write(","+pods[k]["header"])
      pods_file.write("\n")
    except FileExistsError:
      pods_file = open(pf_name, "a")
      for k in pods.keys():
        data[k] = pods[k]
    pods_file.write(str(data[list(data.keys())[0]]["timestamp"]))
    for item in data.keys():
      pods_file.write(","+data[item]["value"])
    pods_file.write("\n")


    s.enter(interval, 1, fetch_pods_metrics, (sc,start,pf_name,data))

#{'metric': {'node': '', 'pod': '', 'sname': 'currencyservice', 'workload': 'currencyservice-w4'}, 'value': [1633946593.309, '0.007184996306714634']}

#first establish connection to prometheus server
prom = PrometheusConnect(url=PROMETHEUS, disable_ssl=True)

start_time = time.time()

## create nodes file slice, print headers
nf_name = "nodes_slice.csv"
nf_name = pathn

#nf = open(nf_name, "w")

## create pods file slice
pf_name = "pods_slice.csv"
pf_name = pathp
#pf = open(pf_name, "w")


s.enter(initial_wait, 2, fetch_nodes_metrics, (s,start_time,nf_name,{}))
s.enter(initial_wait, 1, fetch_pods_metrics, (s,start_time,pf_name,{}))
s.run()
