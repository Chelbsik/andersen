#!/bin/bash

x=1
jq -r '.prices[][]' quotes.json |
while read line
do
   ((x++))
   [ $x -eq 2 ] && { line=$(($line/1000)); date -d @$line; x=0;}
   [ $x -eq 1 ] && echo $line;
done


#M15
#M16
#M17
#M18
#M19
#M20

