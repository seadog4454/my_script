#!/bin/bash

arg_len=$#
strt_d=""
ed_d=""

if [ $arg_len -eq 0  ] ; then
  strt_d="0"
  ed_d="1" 
elif [ $arg_len -eq 1 ] ; then
  echo "0, or 2 arguments is required."
  exit 1
elif [ $arg_len -eq 2 ] ; then
  expr $1 + 1 > /dev/null 2>&1
  is_int_arg1=$?
  expr $2 + 1 > /dev/null 2>&1
  is_int_arg2=$?
  if [ $is_int_arg1 -lt 2 ] && [ $is_int_arg2 -lt 2 ] ; then
    strt_d=$1
    ed_d=$2
  else
    echo "Argument is required int."
    exit 3
  fi
else
  echo "Too many arguments. 0, or 2 arguments is required."
  exit 2
fi

strt_timstnp=$(date --date="$strt_d day" +%Y-%m-%d)    
strt_utc=$(date -d "$strt_timstnp 00:00:00" +%s)
end_timstnp=$(date --date="$ed_d day" +%Y-%m-%d)
end_utc=$(date -d "$end_timstnp 23:59:59" +%s)
event_cal_url="https://ctftime.org/api/v1/events/?limit=100&start=$strt_utc&finish=$end_utc"
#echo $(date -d @$strt_utc)' ~ '$(date -d @$end_utc)
json_data=$(curl -s $event_cal_url)
echo $json_data | jq '.[] | { title: .title, url: .url, ctftime_url: .ctftime_url, start: .start, finish: .finish, onsite: .onsite, description: .description}'

exit 0
