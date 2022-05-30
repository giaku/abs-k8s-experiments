#!/bin/bash

# SCRIPT USED TO START THE STRESS TEST FOR CALIBRATION

#$1 is output folder prefix name
#$2 is the number of iterations each wave must run

if [$1 -e ""]
then
  printf "Folder prefix name parameter is required to keep it tidy.\n"
  exit 1
fi

it=$2
if [$2 -e ""]
then
  printf "Defaulting number of iterations: 1.\n"
  it=1
fi

printf "\n\n\n">> nohup.out
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" >> nohup.out
echo "@@@@@@@@@@@@@@@ NEW TEST STARTING HERE @@@@@@@@@@@@@@@" >> nohup.out
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" >> nohup.out
printf "\n">> nohup.out

nohup ./test.sh $1 $it &

sleep 1
tail -f nohup.out

