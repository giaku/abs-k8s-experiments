PRODUCT_INDEX=$(( ( RANDOM % 8 )))
PRODUCTS=("0PUK6V6EV0" "1YMWWN1N4O" "2ZYFJ3GM2N" "66VCHSJNUP" "6E92ZMYYFZ" "9SIQT8TOJO" "L9ECAV7KIM" "LS4PSXUNUM" "OLJCESPC7Z")
kubectl get pods -n md2 -o wide | grep frontend | awk -v prods="${PRODUCTS[*]}" 'BEGIN {split(prods, PRODUCTS, / /)} {print "GET http://"$6":8080/product/"PRODUCTS[NR%9]}' > targets-pods-wf3.list

