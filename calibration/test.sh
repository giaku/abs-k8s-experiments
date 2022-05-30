#!/bin/bash

# Simulation params
#$1 is the name prefix for the output folder
#$2 is the number of iterations every wave must accomplish

# PARAMETERS CHECK

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


# CONFIGURATION SECTION
#-----|-----|-----|-----|-----|-----|


DURATION=900s
INT_DUR=900

#interval between waves in seconds
interval=450

iterations=$2

# array of workflows entries. Entries can be "wf1", "wf2" or "wf3"
WF=(  "wf2" "wf2" "wf2" "wf2" "wf2" "wf2" "wf2" "wf2" )

# array of integers, RPS entries
RPS=(  "25"  "50"  "75" "100" "125" "150" "175" "200" )

# CAREFULL: RPS and WF arrays must be same length

# END OF CONFIGURATION SECTION
#-----|-----|-----|-----|-----|-----|

length=${#RPS[@]}
printf "Starting calibration stress test... Estimated time: $(((interval+INT_DUR)*iterations*length/60)) minutes\n"

# create working directory
rundir=$1$(date '+%F_%T')
mkdir $rundir

errors=0 # for counting waves with error

# main loop going through stress test waves ("wf1", 100)
for j in ${!RPS[@]}; do

  # create the working subdirectory
  workdir=`echo "$rundir""/${RPS[j]}-${WF[j]}-${RPS2[j]}-${WF2[j]}"`
  mkdir $workdir

  i=1
  # inner loop reiterating the same wave multiple times
  while [ $i -lt $(($iterations+1)) ]
  do
    # update end points
    ./helpers/update-target-pods-${WF[j]}.sh
    sleep 1
  
    printf "Iteration $i of $iterations"
    now=$(date '+%F_%T')
    echo $now >> $workdir/timestamps

    # save timestamps record of each iteration for debug/troubleshooting purposes
    ./helpers/get_interval_from_ts.sh $now $INT_DUR  >> $workdir/timeintervals

    printf "\nWave calibration: ${WF[j]} rate: ${RPS[j]}\n   start: $now\n   duration: $DURATION\n"

    # check if exists and create subdirectory for single iteration
    wavedir=$workdir/wave-iteration-$i
    [ ! -d "$wavedir" ] && mkdir $wavedir

    pod_names_file2=$(echo "$wavedir""/pod_names2_dumps")
    [ ! -d "$pod_names_file2" ] && mkdir $pod_names_file2
    
    # dump pod names in a file BEFORE starting the stress test
    # for checking later that pods haven't changed
    ./helpers/dump_pod_names.sh $pod_names_file2 before md2

    # calculate offset for polling script
    start_offset=$(($INT_DUR*3/10))
    end_offset=$(($INT_DUR*7/10))

    echo "start polling metrics offset $start_offset"
    echo "end polling metrics offset $end_offset"

    # invoke python polling script for fetching Prometheus metrics
    python3.8 /root/new-calibration-old-paper/helpers/polling-script.py $start_offset 15 $end_offset /root/new-calibration-old-paper/$workdir/${WF[j]}-${RPS[j]}-$now-iteration-$i-pods.csv /root/new-calibration-old-paper/$workdir/${WF[j]}-${RPS[j]}-$now-iteration-$i-nodes.csv >> /root/new-calibration-old-paper/$workdir/out-$now.txt &


    # call helper attack which start vegeta tool for sending requests
    ./helpers/attack.sh $DURATION $(echo "${RPS[j]}") $(echo "targets-pods-${WF[j]}.list") $(echo "./$wavedir/out-${WF[j]}-${RPS[j]}-$now.txt") &
    wait

    # dump pod names in a file AFTER running the stress test
    ./helpers/dump_pod_names.sh $pod_names_file2 after md2

    # verify that pod names where identical before and after the stress test
    diffs=$(diff $(echo "$pod_names_file2""/before") $(echo "$pod_names_file2""/after"))

    # if there are no differences -> go on
    if test -z "$diffs"
    then
      i=$[$i+1]
      echo "Result file:"
      echo "./$wavedir/out-${WF[j]}-${RPS[j]}-$now.txt"
    # else there differences -> error
    else
      echo "Something went wrong with 2 nodes deploy... deleting data and repeating iteration $i..."

      # remove timestamps of erroneus iterations
      sed -i '$ d' $workdir/timestamps
      sed -i '$ d' $workdir/timeintervals
      # rename erroneus output and increase error counter
      mv $(echo "./$wavedir/out-${WF[j]}-${RPS[j]}-$now.txt") $(echo "./$wavedir/out-${WF[j]}-${RPS[j]}-$now-error-$errors.txt")
      errors=$(($errors+1))
    fi
    sleep 1
    # remove all evicted pods
    ./helpers/delete_evicted.sh md2
    sleep 3

    # delete and recreate deployments before the next wave
    printf "Deleting deployments...\n"

    ./helpers/delete_deploy.sh md2 frontend-w2
    ./helpers/delete_deploy.sh md2 currencyservice-w2
    ./helpers/delete_deploy.sh md2 recommendationservice-w2
    ./helpers/delete_deploy.sh md2 productcatalogservice-w2
    sleep 3
    printf "Deleted deployments. Now recreating...\n"

    ./helpers/apply_deploy.sh md2 /root/microservices-demo/nodes-deployments/frontend-worker2-2pods.yaml
    ./helpers/apply_deploy.sh md2 /root/microservices-demo/nodes-deployments/currencyservice-worker2-2pods.yaml
    ./helpers/apply_deploy.sh md2 /root/microservices-demo/nodes-deployments/productcatalogservice-worker2-2pods.yaml
    ./helpers/apply_deploy.sh md2 /root/microservices-demo/nodes-deployments/recommendationservice-worker2-2pods.yaml
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
