#!/bin/bash

PROC_NAME() {

if [ -z $1 ]
then
   echo "Specify process name/ID:" > /dev/stderr
   read INPUT
   
   while [ -z $INPUT ]
   do
      echo "Empty process name/ID. Please specify:" > /dev/stderr
      read INPUT
   done
   
   RESULT=$(netstat -tanp | grep $INPUT | awk '/'$INPUT'/ {print $7}' | head -1)

   while [ ! -z $RESULT ]
   do
      echo "Did you mean "$RESULT" (y/n)?" > /dev/stderr
      read CHOICE
      if [[ $CHOICE == 'n' ]]
      then 
           RESULT=''
      elif [[ $CHOICE == 'y' ]]
      then 
         echo $RESULT
         exit 1
      fi
   done

   while [ -z $RESULT ]
   do
      echo "Wrong process name/ID. Please specify:" > /dev/stderr
      read INPUT
      while [ -z $INPUT ]
      do
         echo "Empty process name/ID. Please specify:" > /dev/stderr
         read INPUT
      done
      RESULT=$(netstat -tanp | grep $INPUT | awk '/'$INPUT'/ {print $7}' | head -1)
      while [ ! -z $RESULT ]
      do
         echo "Did you mean "$RESULT" (y/n)?" > /dev/stderr
         read CHOICE
         if [[ $CHOICE == 'n' ]]
         then 
            RESULT=''
         elif [[ $CHOICE == 'y' ]]
         then 
            echo $RESULT
            exit 1
         fi
      done
   done
   echo $RESULT
else
   RESULT=$(netstat -tanp | grep $1 | awk '/'$1'/ {print $7}' | head -1)
   while [ ! -z $RESULT ]
   do
      echo "Did you mean "$RESULT" (y/n)?" > /dev/stderr
      read CHOICE
      if [[ $CHOICE == 'n' ]]
      then 
         RESULT=''
      elif [[ $CHOICE == 'y' ]]
      then 
         echo $RESULT
         exit 1
      fi
   done
   
   while [ -z $RESULT ]
   do
      echo "Wrong process name/ID. Please specify:" > /dev/stderr
      read INPUT
      while [ -z $INPUT ]
      do
         echo "Empty process name/ID. Please specify:" > /dev/stderr
         read INPUT
      done
      RESULT=$(netstat -tanp | grep $INPUT | awk '/'$INPUT'/ {print $7}' | head -1)
      while [ ! -z $RESULT ]
      do
         echo "Did you mean "$RESULT" (y/n)?" > /dev/stderr
         read CHOICE
         if [[ $CHOICE == 'n' ]]
         then 
            RESULT=''
         elif [[ $CHOICE == 'y' ]]
         then 
            echo $RESULT
            exit 1
         fi
      done
   done
   echo $RESULT
fi
}
PID=$(echo $(PROC_NAME $1) | sed 's/\/.*//')

# Read connection type and check it's not empty
echo "Connection state: 1 - TCP, 2 - UDP"
read CON_STATE
[ -z "$CON_STATE" ] && echo "Error: Wrong connection state" && exit 1

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
ALL_CON=$(netstat -$CON_STATE | awk '/'$PID'/ {print $5}' | cut -d: -f1)
MOST_CON_SORT=$(echo "$ALL_CON" | sort | uniq -c | sort)
FIVE_MOST_CON=$(echo "$MOST_CON_SORT" | tail -n5 | grep -oP '(\d+\.){3}\d+')
[ -z "$FIVE_MOST_CON" ] && echo "Sorry, no connections" && exit 1

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

