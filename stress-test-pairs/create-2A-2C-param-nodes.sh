#A X A X

echo "md2 ../microservices-demo/nodes-deployments/redis-cart-worker$2-1pod.yaml
md2 ../microservices-demo/nodes-deployments/redis-cart-worker$4-1pod.yaml
md2 ../microservices-demo/nodes-deployments/cartservice-worker$2-1pod.yaml
md2 ../microservices-demo/nodes-deployments/cartservice-worker$4-1pod.yaml
md2 ../microservices-demo/nodes-deployments/adservice-worker$2-1pod.yaml
md2 ../microservices-demo/nodes-deployments/adservice-worker$4-1pod.yaml
md2 ../microservices-demo/nodes-deployments/frontend-worker$2-2pods.yaml
md2 ../microservices-demo/nodes-deployments/frontend-worker$4-2pods.yaml
md2 ../microservices-demo/nodes-deployments/frontend-worker$1-3pods.yaml
md2 ../microservices-demo/nodes-deployments/frontend-worker$3-3pods.yaml
md2 ../microservices-demo/nodes-deployments/currencyservice-worker$2-2pods.yaml
md2 ../microservices-demo/nodes-deployments/currencyservice-worker$4-2pods.yaml
md2 ../microservices-demo/nodes-deployments/currencyservice-worker$1-2pods.yaml
md2 ../microservices-demo/nodes-deployments/currencyservice-worker$3-2pods.yaml
md2 ../microservices-demo/nodes-deployments/productcatalogservice-worker$2-2pods.yaml
md2 ../microservices-demo/nodes-deployments/productcatalogservice-worker$4-2pods.yaml
md2 ../microservices-demo/nodes-deployments/productcatalogservice-worker$3-2pods.yaml
md2 ../microservices-demo/nodes-deployments/productcatalogservice-worker$1-2pods.yaml
md2 ../microservices-demo/nodes-deployments/recommendationservice-worker$1-3pods.yaml
md2 ../microservices-demo/nodes-deployments/recommendationservice-worker$2-2pods.yaml
md2 ../microservices-demo/nodes-deployments/recommendationservice-worker$3-3pods.yaml
md2 ../microservices-demo/nodes-deployments/recommendationservice-worker$4-2pods.yaml" | xargs -t -n 2 ./helpers/apply_deploy.sh

