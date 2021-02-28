#!/bin/bash

x=1
jq -r '.prices[][]' quotes.json |
while read line
do
   ((x++))
   if [ $x -eq 2 ]
   then 
	echo '1'
	CHECK=$(date -d @$(($line/1000)))
	echo '1.5'
	if [[ $CHECK =~ 'Mar' ]]; then
		echo $CHECK
		x=0
		echo '2'
	fi
   fi
   [ $x -eq 1 ] && echo $line && echo '3'
done


#M15
#M16
#M17
#M18
#M19
#M20

