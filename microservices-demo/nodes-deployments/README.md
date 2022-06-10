# Deployment files from [Online Boutique](https://github.com/GoogleCloudPlatform/microservices-demo/blob/main/release/kubernetes-manifests.yaml)

These files are customised from the original deployment: during the experiments we don't want the system to scale, but rather keep a fixed configuration of pods in every node. Furthermore in the second round of experiments the stress test scripts can switch nodes images <em>on the fly</em> thanks to these deployment files.

To deploy a configuration on worker3 with 2 pods Frontend, 2 pods Currencyservice, 1 pod Redis-cart, 1 pod Adservice, 1 pod Cartservice, 2 pods Productcatalogservice and 2 pods Recommendationservice, we can type this command:

```bash
echo "md ../microservices-demo/nodes-deployments/redis-cart-worker3-1pod.yaml
      md ../microservices-demo/nodes-deployments/cartservice-worker3-1pod.yaml
      md ../microservices-demo/nodes-deployments/adservice-worker3-1pod.yaml
      md ../microservices-demo/nodes-deployments/frontend-worker3-2pods.yaml
      md ../microservices-demo/nodes-deployments/currencyservice-worker3-2pods.yaml
      md ../microservices-demo/nodes-deployments/productcatalogservice-worker3-2pods.yaml
      md ../microservices-demo/nodes-deployments/recommendationservice-worker3-2pods.yaml" | xargs -t -n 2 ./helpers/apply_deploy.sh
```


The helper script ```apply_deploy.sh``` will simply pass the two parameters to ```kubectl apply -n $namesace -f $filepath```.

This solution came very handy for implementing the turnover of node configurations over the virtual machines, see the folders for [pairs](https://github.com/giaku/abs-k8s-experiments/tree/main/stress-test-pairs) and [triplets](https://github.com/giaku/abs-k8s-experiments/tree/main/stress-test-triplets) where are defined very simple scripts to parametrically switch images on VMs thereby (e.g. [create_..._nodes.sh](https://github.com/giaku/abs-k8s-experiments/blob/main/stress-test-triplets/create-3B-1C-param-nodes.sh)).


# IMPORTANT

All deployment resources have the affinity constraints, for different clusters different names must be set. In our experiments four worker nodes were sufficient.

      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: kubernetes.io/hostname
                operator: In
                values:
                - worker--1.novalocal
                
To keep the affinity constraints change the last line of this piece of the yaml files. Where worker1 files will have the name of your actual first worker, and so on for all other workers.
