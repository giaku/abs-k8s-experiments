# abs-k8s-experiments
This repository contains all scripts used to run the experiments on a Kubernetes cluster, many configurations are to be changed in order to replicate the same experiments in another cluster, however the distinction between the main script and the helper scripts should make it straightforward to adapt to different clusters.

In "microservices-demo" that contains the deployment files used during the experiments. The deployments files are provided as they were during the experiments, in order to use them, follow the instructions [microservices-demo/node-deployments folder](https://github.com/giaku/abs-k8s-experiments/tree/main/microservices-demo/nodes-deployments). 

The structure is the same for all the other folders:

<ul>
  <li> <a href="https://github.com/giaku/abs-k8s-experiments/tree/main/calibration">calibration</a> contains the generic scripts for retrieving cost tables data.</li>
  <li> <a href="https://github.com/giaku/abs-k8s-experiments/tree/main/calibration-node-A">calibration-node-A</a> shows an example of how the output folder will look like once the calibration scripts have terminated.</li>
  <li> <a href="https://github.com/giaku/abs-k8s-experiments/tree/main/stress-test-pairs">stress-test-pairs</a> shows an example of how the script from calibration has been modified for running two stress tests simultaneously in order to perform the experiments with pairs of workflows together.</li>
  <li> <a href="https://github.com/giaku/abs-k8s-experiments/tree/main/stress-test-triplets">stress-test-triplets</a> shows an example of the stress test script to perform the experiments with triplets of workflows together.</li>
</ul>

The main script is designed to generate "waves" of one or more workflows invoked with certain RPS. The waves are set in the "CONFIGURATION SECTION" of the main script test.sh. The number of iterations must be passed as parameter on the invocation of the script which can be done directly ./test.sh or via the starter script START.sh.

The README in the subfolders provides further instruction on how to start the stress test.

# Experimental setup:

The scripts must be run on the master node or on a node with the rights edit Kubernetes resources. The stress test tool Vegeta can be run on the master node or elsewhere by by editing the helper script attack.sh which assumes Vegeta is installed on the machine.

In the helper script polling-script.py the URL to the Prometheus instance is hard coded and has to be changed.

Virtual Machine OS: Centos 7

Kubernetes version: 1.19

Prometheus and Grafana stack installed (<a href="https://k21academy.com/docker-kubernetes/prometheus-grafana-monitoring/">see guide</a>) via [helm](https://helm.sh/docs/intro/install/)

[Istio](https://istio.io/latest/docs/setup/getting-started/#download)

[Online boutique](https://github.com/GoogleCloudPlatform/microservices-demo)

Container runtime: Docker 20.10

Python for metrics polling script: 3.8

Stress test tool: [Vegeta](https://github.com/tsenart/vegeta)

