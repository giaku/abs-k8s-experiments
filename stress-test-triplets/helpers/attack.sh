#!/bin/bash
#$1 duration, see vegeta man, for example "200s"
#$2 rate or RPS, for example "200"
#$3 targets file, see vegeta man
#$4 output file

vegeta attack -duration=$1 -rate=$2 -targets=$3 | vegeta report | tee $4
