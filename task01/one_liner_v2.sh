#!/bin/bash

UTIL_NAME() {

if [ ! -z $1 ]
then
    if [[ $1 == 'ss' ]]
    then
        echo 'ss'
    elif [[ $1 == 'netstat' ]]
    then
        [ -z $(command -v netstat) ] && echo 'ss' || echo 'netstat'
    fi
elif [ -z $1 ]
then
    [ -z $(command -v netstat) ] && echo 'ss' || echo 'netstat'
fi
}
[ -z $(UTIL_NAME $1) ] && { echo 'Error: Wrong utility name'; exit 1; }

# Read process name/ID from user, and check it's not empty
echo "Process name or ID:"
read PROC_NAME
[ -z "$PROC_NAME" ] && echo "Error: Empty process name/ID" && exit 1

# Check process name/ID entered correctly 
PROC_NAME_CHECK=$(ss -tup | sed -n '/'\"$PROC_NAME'/p')
PROC_ID_CHECK=$(ss -tup | sed -n '/'=$PROC_NAME'/p')
[ -z "$PROC_NAME_CHECK" ] && [ -z "$PROC_ID_CHECK" ] && echo "Error: Wrong process name/ID" && exit 1

# Read connection type and check it's not empty
echo "Connection state: 1 - TCP, 2 - UDP"
read CON_STATE
[ -z "$CON_STATE" ] && echo "Error: Empty connection state" && exit 1

# Check utility and execute corresponding chain
if [[ "$(UTIL_NAME $1)" == 'netstat' ]]
then

    # Check connection type 
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

    # Pick IP addresses
    ALL_CON=$(netstat -$CON_STATE | awk '/'$PROC_NAME'/ {print $5}' | cut -d: -f1)
    MOST_CON_SORT=$(echo "$ALL_CON" | sort | uniq -c | sort)
    FIVE_MOST_CON=$(echo "$MOST_CON_SORT" | tail -n5 | grep -oP '(\d+\.){3}\d+')
    [ -z "$FIVE_MOST_CON" ] && echo "Sorry, no connections" && exit 1
    
elif [[ "$(UTIL_NAME $1)" == 'ss' ]]
then

    # Check connection type 
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

    # Pick IP addresses
    ALL_CON_LINES=$(ss -$CON_STATE | sed -n '/'$PROC_NAME'/p' | sed -rn '/([0-9]{1,3}\.){3}[0-9]{1,3}/p')
    CUT_ALL_CON=$(echo "$ALL_CON_LINES" | sed 's/\([^ ]* *\)\{4\}\([^ ]* *\)[^ ]* */\2/')
    MOST_CON_SORT=$(echo "$CUT_ALL_CON" | sed 's/:.*//' | sort | uniq -c | sort)
    FIVE_MOST_CON=$(echo "$MOST_CON_SORT" | tail -n5 | sed 's/ *[^ ] //')
    [ -z "$FIVE_MOST_CON" ] && echo "Sorry, no connections" && exit 1

fi

# Finally, print required information...
echo '-----------------------------------------------------'

echo "$FIVE_MOST_CON" | while read IP 
do
    whois $IP | awk -F':' '/^Organization/ || /^Address/ || /^City/ || /^Country/ {print $0}'
done

echo '-----------------------------------------------------'

# ... and onnections counter
echo "$FIVE_MOST_CON" | while read IP
do
    whois $IP | awk -F':' '/^Organization/ {print $2}'
done | sort | uniq -c |
while read COUNTER
do
    echo "Connections: $COUNTER"
done

echo '-----------------------------------------------------'