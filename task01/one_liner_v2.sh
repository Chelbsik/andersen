#!/bin/bash

echo "Process name or ID:"
read PROC_NAME
PROC_NAME_CHECK=$(ss -tup | sed -n '/'$PROC_NAME'/p' )
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

MEAT_PART=$(ss -$CON_STATE | sed -n '/firefox/p' | sed -rn '/([0-9]{1,3}\.){3}[0-9]{1,3}/p' | sed 's/\([^ ]* *\)\{4\}\([^ ]* *\)[^ ]* */\2/' | sed 's/:.*//' | sort | uniq -c | sort | tail -n5 | sed 's/ *[^ ] //')
[ -z "$MEAT_PART" ] && echo "Sorry, no connections" && exit 1

echo "$MEAT_PART" | while read IP 
do
   whois $IP | awk -F':' '/^Organization/ || /^Address/ || /^City/ || /^Country/ {print $0}'
done

echo '-----------------------------------------------------'

echo "$MEAT_PART" | while read IP
do
   whois $IP | awk -F':' '/^Organization/ {print $2}'
done | sort | uniq -c |
while read COUNTER
do
   echo "Connections: $COUNTER"
done

echo '-----------------------------------------------------'

