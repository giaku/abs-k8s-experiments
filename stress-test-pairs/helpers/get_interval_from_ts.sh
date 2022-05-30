#!/bin/bash
#$1 is the timestamp in the format
#$2 is the wave duration in seconds
#$3 is a ratio telling where to start cutting (hardcoded4now)
#$4 is a ratio telling where to stop cutting (hardcoded4now)

timestamp=`echo $1 | tr _ ' '`

seconds_ts=`date --date="$timestamp" "+%s"`

start_offset=$(($2*3/10))
end_offset=$(($2*7/10))

#echo "start $start_offset"
#echo "end $end_offset"
#echo "from wave timestamp $timestamp to interval:"
#echo "seconds $seconds_ts"


interval_start_seconds=$(($seconds_ts+$start_offset))
interval_end_seconds=$(($seconds_ts+$end_offset))


interval_start=`date -d @$interval_start_seconds +'%Y-%m-%d_%H:%M:%S'`
interval_end=`date -d @$interval_end_seconds +'%Y-%m-%d_%H:%M:%S'`
echo "$interval_start $interval_end"
#echo "end: $interval_end"
