#!/bin/bash

# Simulation params
#$1 is the name prefix for the folder
#$2 is the number of iterations every wave must accomplish

if [$1 -e ""]
then
  printf "Folder prefix name parameter is required to keep it tidy.\n"
  exit 1
fi

if [$2 -e ""]
then
  printf "Please insert the number of iterations that you always forget to change as second param.\n"
  exit 1
fi

DURATION=900s
INT_DUR=900

#interval between waves in seconds
interval=360

iterations=$2


WF=( "wf3" "wf3" "wf3" "wf3" "wf3" "wf3" "wf3" "wf3" )

RPS=( "25" "50" "75" "100" "125" "150" "175" "200" )

#-----|-----|-----|-----|-----|-----|

length=${#RPS[@]}
printf "Starting calibration stress test... Estimated time: $(((interval+INT_DUR)*iterations*length/60)) minutes\n"

rundir=$1$(date '+%F_%T')
mkdir $rundir

errors=0

for j in ${!RPS[@]}; do

  workdir=`echo "$rundir""/${RPS[j]}-${WF[j]}-"`

  mkdir $workdir

  i=1
  while [ $i -lt $(($iterations+1)) ]
  do
    ./helpers/update-target-pods-${WF[j]}.sh
    sleep 1
  
    printf "Iteration $i of $iterations"
    now=$(date '+%F_%T')
    echo $now >> $workdir/timestamps
    ./helpers/get_interval_from_ts.sh $now $INT_DUR  >> $workdir/timeintervals
    printf "\nWave calibration: ${WF[j]} rate: ${RPS[j]}\n   start: $now\n   duration: $DURATION\n"
    wavedir=$workdir/wave-iteration-$i
    [ ! -d "$wavedir" ] && mkdir $wavedir

    pod_names_file2=$(echo "$wavedir""/pod_names2_dumps")
    [ ! -d "$pod_names_file2" ] && mkdir $pod_names_file2
    ./helpers/dump_pod_names.sh $pod_names_file2 before md2

    start_offset=$(($INT_DUR*3/10))
    end_offset=$(($INT_DUR*7/10))

    echo "start polling metrics offset $start_offset"
    echo "end polling metrics offset $end_offset"

    python3.8 ./helpers/polling-script.py $start_offset 15 $end_offset ./$workdir/${WF[j]}-${RPS[j]}-$now-iteration-$i-pods.csv ./$workdir/${WF[j]}-${RPS[j]}-$now-iteration-$i-nodes.csv >> ./$workdir/out-$now.txt &

    ./helpers/attack.sh $DURATION $(echo "${RPS[j]}") $(echo "targets-pods-${WF[j]}.list") $(echo "./$wavedir/out-${WF[j]}-${RPS[j]}-$now.txt")
    
    ./helpers/dump_pod_names.sh $pod_names_file2 after md2
    diffs=$(diff $(echo "$pod_names_file2""/before") $(echo "$pod_names_file2""/after"))

    if test -z "$diffs"
    then
      i=$[$i+1]
      echo "Result file:"
      echo "./$wavedir/out-${WF[j]}-${RPS[j]}-$now.txt"
    else
      echo "Something went wrong with 2 nodes deploy... deleting data and repeating iteration $i..."
      sed -i '$ d' $workdir/timestamps
      sed -i '$ d' $workdir/timeintervals
      mv $(echo "./$wavedir/out-${WF[j]}-${RPS[j]}-$now.txt") $(echo "./$wavedir/out-${WF[j]}-${RPS[j]}-$now-error-$errors.txt")
      errors=$(($errors+1))
    fi
    sleep 1
    ./helpers/delete_evicted.sh md2
    sleep 3

    printf "Deleting deployments frontend and currencyservice\n"

    ./helpers/delete_deploy.sh md2 frontend-w2
    ./helpers/delete_deploy.sh md2 currencyservice-w2
    ./helpers/delete_deploy.sh md2 recommendationservice-w2
    ./helpers/delete_deploy.sh md2 productcatalogservice-w2

    sleep 3
    printf "Deleted currencyservice and frontend deployments. Now recreating...\n"

    ./helpers/apply_deploy.sh md2 ../microservices-demo/nodes-deployments/frontend-worker2-2pods.yaml
    ./helpers/apply_deploy.sh md2 ../microservices-demo/nodes-deployments/currencyservice-worker2-2pods.yaml
    ./helpers/apply_deploy.sh md2 ../microservices-demo/nodes-deployments/productcatalogservice-worker2-2pods.yaml
    ./helpers/apply_deploy.sh md2 ../microservices-demo/nodes-deployments/recommendationservice-worker2-2pods.yaml

    sleep 3
    printf "Recreated frontend and currencyservice deployments\n"

    printf "vegeta resting for $interval seconds...\n"
    sleep $interval
    printf "Finished workflows ${WF[j]} at rate ${RPS[j]} - iteration $(($i-1))\n"
  done
  echo "Finished"
done
echo "Total errors: $errors"
exit 0
