#!/bin/bash

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

outfile=exec.out

printf "\n\n\n">> $outfile
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" >> $outfile
echo "@@@@@@@@@@@@@@@ NEW TEST STARTING HERE @@@@@@@@@@@@@@@" >> $outfile
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@" >> $outfile
printf "\n">> $outfile

nohup ./test.sh $1 $it >> $outfile 2>&1 &

sleep 1
#tail -f $outfile

