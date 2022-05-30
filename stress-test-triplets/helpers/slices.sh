
#$1 is the csv file
#$2 is the time intervals $folder
#$3 is the name template we want to give to the slices that will be in $folder/csvs/$filename-$iteration
cat $1 | awk -v folder=$2 -v filename=$3 '

BEGIN {

  cmd1="date +%s -d "
  file=folder"/timeintervals"
  i=1
  while (getline < file)
  {
    split($0,entries," ")
    endtime[i]=entries[2]
    starttime[i]=entries[1]
    print "Interval loaded - start "starttime[i]" end "endtime[i]
    i=i+1
  }
  N_intervals=i-1
  close(file)
}

{
  if(NR==1) {split($0,tokens,"="); SEP=""tokens[2]} else {
  if(NR==2) {HEADERS=$0} else {
    for(i=1; i<=N_intervals; i++) {
      split(starttime[i], tokenz, "_")
      split(tokenz[1], tokens, "-")
      split(tokenz[2], times, ":")

      START=mktime(tokens[1]" "tokens[2]" "tokens[3]" "times[1]" "times[2]" "times[3])
      debug1=""tokens[1]" "tokens[2]" "tokens[3]" "times[1]" "times[2]" "times[3]
      split(endtime[1], tokenz, "_")
      split(tokenz[1], tokens, "-")
      split(tokenz[2], times, ":")
      
      split(endtime[i], tokenz, "_")
      split(tokenz[1], tokens, "-")
      split(tokenz[2], times, ":")

      FINE=mktime(tokens[1]" "tokens[2]" "tokens[3]" "times[1]" "times[2]" "times[3])
      debug2=""tokens[1]" "tokens[2]" "tokens[3]" "times[1]" "times[2]" "times[3]
      split($0, tokens, ",")
      split(tokens[1], datetokens, " ")
      split(datetokens[1], datetokenz, "-")
      split(datetokens[2], timetokens, ":")
    
      CURRENT=mktime(datetokenz[1]" "datetokenz[2]" "datetokenz[3]" "timetokens[1]" "timetokens[2]" "timetokens[3])
      debug3=""datetokenz[1]" "datetokenz[2]" "datetokenz[3]" "timetokens[1]" "timetokens[2]" "timetokens[3]
      F=folder""filename"-"starttime[i]"-iteration-"i".csv"
#print F
      if(NR==3) {print HEADERS > F}
      if(CURRENT>=START && CURRENT<=FINE) {print $0 >> F} 
  }}
}}

END {
  #print OFF1, OFF2
}'

