#!/bin/bash

echo "Process name or ID:"
read PROC_NAME
PROC_NAME_CHECK=$(ss -tup | sed -n '/'$PROC_NAME'/p')
[ -z "$PROC_NAME" ] || [[ ! $PROC_NAME_CHECK =~ [:digit:] ]] && echo "Error: Wrong process name/ID" && exit 1

echo "Connection state: 1 - TCP, 2 - UDP"
read CON_STATE
[ -z "$CON_STATE" ] && echo "Error: Wrong connection state" && exit 1

if [ $CON_STATE == 1 ]
then
   CON_STATE="tp"
elif [ $CON_STATE == 2 ]
then
   CON_STATE="up"
else
   echo "Error: Wrong connection state"
   exit 1
fi

echo '-----------------------------------------------------'

ALL_CON_LINES=$(ss -$CON_STATE | sed -n '/'$PROC_NAME'/p' | sed -rn '/([0-9]{1,3}\.){3}[0-9]{1,3}/p')
CUT_ALL_CON=$(echo "$ALL_CON_LINES" | sed 's/\([^ ]* *\)\{4\}\([^ ]* *\)[^ ]* */\2/')
MOST_CON_SORT=$(echo "$CUT_ALL_CON" | sed 's/:.*//' | sort | uniq -c | sort)
FIVE_MOST_CON=$(echo "$MOST_CON_SORT" | tail -n5 | sed 's/ *[^ ] //')
[ -z "$FIVE_MOST_CON" ] && echo "Sorry, no connections" && exit 1

echo "$FIVE_MOST_CON" | while read IP
do
   whois $IP | awk -F':' '/^Organization/ || /^Address/ || /^City/ || /^Country/ {print $0}'
done

echo '-----------------------------------------------------'

echo "$FIVE_MOST_CON" | while read IP
do
   whois $IP | awk -F':' '/^Organization/ {print $2}'
done | sort | uniq -c |
while read COUNTER
do
   echo "Connections: $COUNTER"
done

echo '-----------------------------------------------------'
