

filename=ps-$1$2.$(date -d '+2 hour' '+%F_%T')_$4.txt
filepath=$3/scheduling_dumps

echo "Pod scheduling $4 attack available in file $filepath/$filename"
kubectl get pods -n md2 -o wide | grep Running | awk '{split($1, TOKENS, "-"); split($7, TOKENZ, "."); print TOKENS[1] " " TOKENZ[1]}' | sort | uniq -c | sort > $filepath/$filename
