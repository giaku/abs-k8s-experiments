# abs-k8s-experiments
This repository contains all scripts used to run the experiments on a Kubernetes cluster, many configurations are to be changed in order to replicate the same experiments in another cluster, however the distinction between the main script and the helper scripts should make it straightforward to adapt to different clusters.

In "microservices-demo" that contains the deployment files used during the experiments. The deployments files are provided as they were during the experiments, in order to use them, follow the instructions [microservices-demo/node-deployments folder](https://github.com/giaku/abs-k8s-experiments/tree/main/microservices-demo/nodes-deployments). 

The structure is the same for all the other folders:

<ul>
  <li>"calibration" contains the generic scripts for retrieving cost tables data.</li>
  <li>"calibration-node-A" shows an example of how the output folder will look like once the calibration scripts have terminated.</li>
  <li>"stress-test-pairs" shows an example of how the script from calibration has been modified for running two stress tests simultaneously in order to perform the experiments with pairs of workflows together.</li>
  <li>"stress-test-triplets" shows an example of the stress test script to perform the experiments with triplets of workflows together.</li>
</ul>

# Experimental setup:

The scripts must be run on the master node or on a node with the rights edit Kubernetes resources. The stress test tool Vegeta can be run on the master node or elsewhere by by editing the helper script attack.sh which assumes Vegeta is installed on the machine.



Virtual Machine OS: Centos 7

Kubernetes version: 1.19

Container runtime: Docker 20.10

Python for metrics polling script: 3.8

Stress test tool: Vegeta (https://github.com/tsenart/vegeta)

