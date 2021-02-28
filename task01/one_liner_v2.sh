#!/bin/bash

echo "Process name or ID:"
read PROC_NAME
<<<<<<< HEAD
PROC_NAME_CHECK=$(ss -tup | sed -n '/'$PROC_NAME'/p' )
[ -z "$PROC_NAME" ] || [[ ! $PROC_NAME_CHECK =~ [:digit:] ]] && echo "Error: Wrong process name/ID" && exit 1
=======
[ -z "$PROC_NAME" ] && echo "Error: Empty process name/ID" && exit 1

PROC_NAME_CHECK=$(ss -tup | sed -n '/'\"$PROC_NAME'/p')
PROC_ID_CHECK=$(ss -tup | sed -n '/'=$PROC_NAME'/p')
[ -z "$PROC_NAME_CHECK" ] && [ -z "$PROC_ID_CHECK" ] && echo "Error: Wrong process name/ID" && exit 1
>>>>>>> test

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

<<<<<<< HEAD
MEAT_PART=$(ss -$CON_STATE | sed -n '/firefox/p' | sed -rn '/([0-9]{1,3}\.){3}[0-9]{1,3}/p' | sed 's/\([^ ]* *\)\{4\}\([^ ]* *\)[^ ]* */\2/' | sed 's/:.*//' | sort | uniq -c | sort | tail -n5 | sed 's/ *[^ ] //')
[ -z "$MEAT_PART" ] && echo "Sorry, no connections" && exit 1

echo "$MEAT_PART" | while read IP 
=======
ALL_CON_LINES=$(ss -$CON_STATE | sed -n '/'$PROC_NAME'/p' | sed -rn '/([0-9]{1,3}\.){3}[0-9]{1,3}/p')
CUT_ALL_CON=$(echo "$ALL_CON_LINES" | sed 's/\([^ ]* *\)\{4\}\([^ ]* *\)[^ ]* */\2/')
MOST_CON_SORT=$(echo "$CUT_ALL_CON" | sed 's/:.*//' | sort | uniq -c | sort)
FIVE_MOST_CON=$(echo "$MOST_CON_SORT" | tail -n5 | sed 's/ *[^ ] //')
[ -z "$FIVE_MOST_CON" ] && echo "Sorry, no connections" && exit 1
echo "$ALL_CON_LINES"
echo +
echo "$CUT_ALL_CON"
echo ++
echo "$MOST_CON_SORT"
echo +++
echo "$FIVE_MOST_CON"
echo ++++
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
<<<<<<< HEAD

=======
>>>>>>> test
