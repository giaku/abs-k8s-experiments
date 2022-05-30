# Fetch pod ips for frontend service for application Online Boutique
# and create targets file for Workflow 2

ns=md2
svc=frontend
port=8080

kubectl get pods -n $ns -o wide | grep $svc | awk  -v port="$port" '{print "POST http://"$6":"port"/setCurrency\n@helpers/wf2args.json"}' > targets-pods-wf2.list

