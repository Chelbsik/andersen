#!/bin/bash

echo "Process name or ID:"
read PROC_NAME
<<<<<<< HEAD
PROC_NAME_CHECK=$(netstat -tunapl | awk '/'$PROC_NAME'/ {print $5}' )
[ -z "$PROC_NAME" ] || [[ ! $PROC_NAME_CHECK =~ [:digit:] ]] && echo "Error: Wrong process name/ID" && exit 1
=======
[ -z "$PROC_NAME" ] && echo "Error: Empty process name/ID" && exit 1

PROC_NAME_CHECK=$(netstat -tunapl | awk '/[\/]'$PROC_NAME'/ {print $5}')
PROC_ID_CHECK=$(netstat -tunapl | awk '/'$PROC_NAME'[\/]/ {print $5}')
[ -z "$PROC_NAME_CHECK" ] && [ -z "$PROC_ID_CHECK" ] && echo "Error: Wrong process name/ID" && exit 1
>>>>>>> test

echo "Connection state: 1 - TCP, 2 - UDP"
read CON_STATE
[ -z "$CON_STATE" ] && echo "Error: Wrong connection state" && exit 1

if [ $CON_STATE == 1 ]
then
   CON_STATE="tanp"
elif [ $CON_STATE == 2 ]
then
   CON_STATE="unpa"
else
   echo "Error: Wrong connection state"
   exit 1
fi

echo '-----------------------------------------------------'

<<<<<<< HEAD
MEAT_PART=$(netstat -$CON_STATE | awk '/'$PROC_NAME'/ {print $5}' | cut -d: -f1 | sort | uniq -c | sort | tail -n5 | grep -oP '(\d+\.){3}\d+')
[ -z "$MEAT_PART" ] && echo "Sorry, no connections" && exit 1

echo "$MEAT_PART" | while read IP 
=======
ALL_CON=$(netstat -$CON_STATE | awk '/'$PROC_NAME'/ {print $5}' | cut -d: -f1)
MOST_CON_SORT=$(echo "$ALL_CON" | sort | uniq -c | sort)
FIVE_MOST_CON=$(echo "$MOST_CON_SORT" | tail -n5 | grep -oP '(\d+\.){3}\d+')
[ -z "$FIVE_MOST_CON" ] && echo "Sorry, no connections" && exit 1

echo "$FIVE_MOST_CON" | while read IP 
>>>>>>> test
do
   whois $IP | awk -F':' '/^Organization/ || /^Address/ || /^City/ || /^Country/ {print $0}'
done

echo '-----------------------------------------------------'

<<<<<<< HEAD
echo "$MEAT_PART" | while read IP
=======
echo "$FIVE_MOST_CON" | while read IP
>>>>>>> test
do
   whois $IP | awk -F':' '/^Organization/ {print $2}'
done | sort | uniq -c |
while read COUNTER
do
   echo "Connections: $COUNTER"
done

echo '-----------------------------------------------------'

