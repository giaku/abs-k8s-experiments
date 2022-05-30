#!/bin/bash

if [ -z "$1" ]
then
  printf "Folder prefix name parameter is required to keep it tidy.\n"
  exit 1
fi

it=$2
if [ -z "$2" ]
then
  printf "Defaulting number of iterations: 1.\n"
  it=1
fi

outfile=$1exec.out

printf "\n\n\n">> $outfile
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" >> $outfile
echo "@@@@@@@@@@@@@@@ NEW TEST STARTING HERE @@@@@@@@@@@@@@@" >> $outfile
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" >> $outfile
printf "\n">> $outfile

nohup ./test.sh $1 $it $3 >> $outfile 2>&1 &

sleep 1
#tail -f $outfile

