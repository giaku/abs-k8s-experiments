#E B B B

echo "md2 /root/microservices-demo/nodes-deployments/redis-cart-worker$1-1pod.yaml
md2 /root/microservices-demo/nodes-deployments/cartservice-worker$1-1pod.yaml
md2 /root/microservices-demo/nodes-deployments/adservice-worker$1-1pod.yaml
md2 /root/microservices-demo/nodes-deployments/frontend-worker$1-1pod.yaml
md2 /root/microservices-demo/nodes-deployments/frontend-worker$4-4pods.yaml
md2 /root/microservices-demo/nodes-deployments/frontend-worker$2-4pods.yaml
md2 /root/microservices-demo/nodes-deployments/frontend-worker$3-4pods.yaml
md2 /root/microservices-demo/nodes-deployments/currencyservice-worker$1-1pod.yaml
md2 /root/microservices-demo/nodes-deployments/currencyservice-worker$4-3pods.yaml
md2 /root/microservices-demo/nodes-deployments/currencyservice-worker$2-3pods.yaml
md2 /root/microservices-demo/nodes-deployments/currencyservice-worker$3-3pods.yaml
md2 /root/microservices-demo/nodes-deployments/productcatalogservice-worker$1-3pods.yaml
md2 /root/microservices-demo/nodes-deployments/productcatalogservice-worker$4-1pod.yaml
md2 /root/microservices-demo/nodes-deployments/productcatalogservice-worker$3-1pod.yaml
md2 /root/microservices-demo/nodes-deployments/productcatalogservice-worker$2-1pod.yaml
md2 /root/microservices-demo/nodes-deployments/recommendationservice-worker$2-1pod.yaml
md2 /root/microservices-demo/nodes-deployments/recommendationservice-worker$1-3pods.yaml
md2 /root/microservices-demo/nodes-deployments/recommendationservice-worker$3-1pod.yaml
md2 /root/microservices-demo/nodes-deployments/recommendationservice-worker$4-1pod.yaml" | xargs -t -n 2 ./helpers/apply_deploy.sh

