#!/bin/bash

#original
#jq -r '.prices[][]' quotes.json | grep -oP '\d+\.\d+'

#version withour pattern matching
jq -r '.prices[][]' quotes.json | 
while read line
do
    ((x++))
    [ $x -eq 2 ] && { echo $line; x=0;}
done
