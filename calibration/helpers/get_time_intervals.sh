

cat $1 | awk -v DURATION="$2" '

BEGIN {

  OFF1=int(DURATION*3/10)
  OFF2=int(DURATION*7/10)
 
  cmd1="date +%s -d "
}

{

  split($1, tokens, "-")
  split(tokens[4], times, ":")

  DATE=tokens[1]" "tokens[2]" "tokens[3]" "times[1]" "times[2]" "times[3]

  start=mktime(DATE)
  startw=strftime("%y-%m-%d-%H:%M:%S",start)
  end=start+OFF2
  start=start+OFF1
   
  startd=strftime("%y-%m-%d-%H:%M:%S",start)
  endd=strftime("%y-%m-%d-%H:%M:%S",end)
  
  #print "Timestamp: " startw
  #print " --- INTERVAL START: " startd " --- INTERVAL END: " endd
  print startd" "endd
}

END {

  #print OFF1, OFF2

}'

