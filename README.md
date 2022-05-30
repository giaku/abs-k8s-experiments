# abs-k8s-experiments
This repository contains all scripts used to run the experiments on a OpenStack cluster.

Folder "calibration" contains the generic scripts for retrieving cost tables data.

Folder "calibration-node-A" shows an example of how the output folder will look like once the calibration scripts have terminated.

Folder "stress-test-pairs" shows an example of how the script from calibration has been modified for running two stress tests simultaneously in order to perform the experiments with pairs of workflows together.

# Requirements:

Virtual Machine OS: Centos 7

Kubernetes version: 1.19

Container runtime: Docker

Python for metrics polling script: 3.8

Stress test tool: Vegeta (https://github.com/tsenart/vegeta)

