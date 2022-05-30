# Fetch pod ips for frontend service for application Online Boutique
# and create targets file for Workflow 1

ns=md2
svc=frontend
port=8080

kubectl get pods -n $ns -o wide | grep $svc | awk  -v port="$port" '{print "GET http://"$6":"port"/"}' > targets-pods-wf1.list

