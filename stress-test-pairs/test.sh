#!/bin/bash

# Simulation params
#$1 is the name prefix for the folder
#$2 is the number of iterations every wave must accomplish
#$3 is true for nodes turnover, false otherwise. Default false.

# PARAMETERS CHECK

if [ -z "$1" ]
then
  printf "Folder prefix name parameter is required to keep it tidy.\n"
  exit 1
fi

if [ -z "$2" ]
then
  printf "Please insert the number of iterations that you always forget to change as second param.\n"
  exit 1
fi

turnover=$3

if [ -z "$3" ]
then
  printf "Nodes turnover off by default\n"
  turnover=false
fi

# CONFIGURATION SECTION
#-----|-----|-----|-----|-----|-----|

DURATION=900s
INT_DUR=900

#interval between waves in seconds
interval=360

iterations=$2

WF=(   "wf1" "wf1" "wf1" "wf1")
RPS=(  "100" "300" "150" "150")

WF2=(  "wf3" "wf2" "wf2" "wf3")
RPS2=( "100" "100" "350" "350")

WF=(  "wf1" "wf1" "wf1" "wf3")
RPS=( "100" "100" "175" "150")

WF2=(  "wf3" "wf3" "wf2" "wf2")
RPS2=( "100" "200" "100" "150")


# CAREFULL: RPS and WF arrays must be same length

# END OF CONFIGURATION SECTION
#-----|-----|-----|-----|-----|-----|

length=${#RPS[@]}
printf "Starting calibration stress test... Estimated time: $(((interval+INT_DUR)*iterations*length/60)) minutes\n"

rundir=$1$(date '+%F_%T')
mkdir $rundir

errors=0

w1=1
w2=2
w3=3
w4=4

shifts=0

while [ "$shifts" -ne "4" ]
do
for j in ${!RPS[@]}; do

  workdir=`echo "$rundir""/${RPS[j]}-${WF[j]}-${RPS2[j]}-${WF2[j]}"`

  mkdir $workdir

  i=1
  while [ $i -lt $(($iterations+1)) ]
  do
    ./helpers/update-target-pods-${WF[j]}.sh
    ./helpers/update-target-pods-${WF2[j]}.sh
    sleep 1
  
    printf "Iteration $i of $iterations"
    now=$(date '+%F_%T')
    echo $now >> $workdir/timestamps
    ./helpers/get_interval_from_ts.sh $now $INT_DUR  >> $workdir/timeintervals
    printf "\nWave calibration: ${WF[j]} rate: ${RPS[j]}\n   start: $now\n   duration: $DURATION\n"
    printf "\nTogether with wave calibration: ${WF2[j]} rate: ${RPS2[j]}\n   start: $now\n   duration: $DURATION\n"
    wavedir=$workdir/wave-iteration-$i
    [ ! -d "$wavedir" ] && mkdir $wavedir

    pod_names_file2=$(echo "$wavedir""/pod_names2_dumps")
    [ ! -d "$pod_names_file2" ] && mkdir $pod_names_file2
    ./helpers/dump_pod_names.sh $pod_names_file2 before md2

    start_offset=$(($INT_DUR*3/10))
    end_offset=$(($INT_DUR*7/10))

    echo "start polling metrics offset $start_offset"
    echo "end polling metrics offset $end_offset"

    python3.8 ./helpers/polling-script.py $start_offset 15 $end_offset ./$workdir/${WF[j]}-${RPS[j]}-${WF2[j]}-${RPS2[j]}-$now-iteration-$i-pods.csv ./$workdir/${WF[j]}-${RPS[j]}-${WF2[j]}-${RPS2[j]}-$now-iteration-$i-nodes.csv ./$workdir/${WF[j]}-${RPS[j]}-${WF2[j]}-${RPS2[j]}-$now-iteration-$i-pods-no-istio.csv >> ./$workdir/out-$now.txt $shifts &

    ./helpers/attack.sh $DURATION $(echo "${RPS[j]}") $(echo "targets-pods-${WF[j]}.list") $(echo "./$wavedir/out-${WF[j]}-${RPS[j]}-$now.txt") &
    ./helpers/attack.sh $DURATION $(echo "${RPS2[j]}") $(echo "targets-pods-${WF2[j]}.list") $(echo "./$wavedir/out-${WF2[j]}-${RPS2[j]}-$now.txt")
    wait

    ./helpers/dump_pod_names.sh $pod_names_file2 after md2
    diffs=$(diff $(echo "$pod_names_file2""/before") $(echo "$pod_names_file2""/after"))

    if test -z "$diffs"
    then
      i=$[$i+1]
      echo "Result file:"
      echo "./$wavedir/out-${WF[j]}-${RPS[j]}-${WF2[j]}-${RPS2[j]}-$now.txt"
    else
      echo "Something went wrong with 2 nodes deploy... deleting data and repeating iteration $i..."
      sed -i '$ d' $workdir/timestamps
      sed -i '$ d' $workdir/timeintervals
      mv $(echo "./$wavedir/out-${WF[j]}-${RPS[j]}-${WF2[j]}-${RPS2[j]}-$now.txt") $(echo "./$wavedir/out-${WF[j]}-${RPS[j]}-${WF2[j]}-${RPS2[j]}-$now-error-$errors.txt")
      errors=$(($errors+1))
    fi
    sleep 1
    ./helpers/delete_evicted.sh md2
    sleep 3

    printf "Deleting deployments frontend and currencyservice\n"

    ./delete-2A-2B-param.sh $w1	$w2 $w3	$w4

    sleep 3
    printf "Deleted currencyservice and frontend deployments. Now recreating...\n"

    ./create-2A-2B-param-nodes.sh $w1 $w2 $w3 $w4

    sleep 3
    printf "Recreated frontend, currencyservice, recommendationservice and productcatalogservice deployments\n"

    printf "vegeta resting for $interval seconds...\n"
    sleep $interval
    printf "Finished workflows ${WF[j]} at rate ${RPS[j]} with ${WF2[j]} at rate ${RPS2[j]} - iteration $(($i-1))\n"
  done
  echo "Finished couple ${WF[j]} ${WF2[j]} with rates: ${RPS[j]} ${RPS2[j]}"
done

if [ "$turnover" == true  ]
then
  ./delete-2A-2B-param.sh $w1 $w2 $w3 $w4
  sleep 5
  tmp=$w1
  w1=$w2
  w2=$w3
  w3=$w4
  w4=$tmp
  shifts=$(($shifts+1))
  printf "\nShifting nodes...\n"
  ./create-2A-2B-param-nodes.sh $w1 $w2 $w3 $w4
  sleep 30
else
  break
fi
done
echo "Total errors: $errors"

exit 0
