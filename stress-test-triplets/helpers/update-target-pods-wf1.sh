kubectl get pods -n md2 -o wide | grep frontend | awk '{print "GET http://"$6":8080/"}' > targets-pods-wf1.list

