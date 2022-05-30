
echo "md2 adservice-w$4
md2 adservice-w$2
md2 cartservice-w$4
md2 cartservice-w$2
md2 redis-cart-w$2
md2 redis-cart-w$4
md2 frontend-w$2
md2 frontend-w$4
md2 frontend-w$1
md2 frontend-w$3
md2 currencyservice-w$2
md2 currencyservice-w$4
md2 currencyservice-w$1
md2 currencyservice-w$3
md2 recommendationservice-w$1
md2 recommendationservice-w$2
md2 recommendationservice-w$3
md2 recommendationservice-w$4
md2 productcatalogservice-w$2
md2 productcatalogservice-w$4
md2 productcatalogservice-w$1
md2 productcatalogservice-w$3" | xargs -t -n 2 ./helpers/delete_deploy.sh 
