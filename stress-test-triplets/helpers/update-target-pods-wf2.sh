kubectl get pods -n md2 -o wide | grep frontend | awk '{print "POST http://"$6":8080/setCurrency\n@helpers/wf2args.json"}' > targets-pods-wf2.list

