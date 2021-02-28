#!/bin/bash

DATE_VAL_TUPLE=$(jq '.prices[][0] |= ( . /1000 | strftime("%Y-%m-%d"))' quotes.json | 
jq -c '.prices[]')

M15=$(echo "$DATE_VAL_TUPLE" | grep '2015-03')
M16=$(echo "$DATE_VAL_TUPLE" | grep '2016-03')
M17=$(echo "$DATE_VAL_TUPLE" | grep '2017-03')
M18=$(echo "$DATE_VAL_TUPLE" | grep '2018-03')
M19=$(echo "$DATE_VAL_TUPLE" | grep '2019-03')
M20=$(echo "$DATE_VAL_TUPLE" | grep '2020-03')

M15_MIN=$(echo "$M15" | cut -d ',' -f2 | cut -d ']' -f1 | sort | jq -s min)
M15_MAX=$(echo "$M15" | cut -d ',' -f2 | cut -d ']' -f1 | sort | jq -s max)
M15_DIFF=$(awk "BEGIN {print $M15_MAX - $M15_MIN}")

M16_MIN=$(echo "$M16" | cut -d ',' -f2 | cut -d ']' -f1 | sort | jq -s min)
M16_MAX=$(echo "$M16" | cut -d ',' -f2 | cut -d ']' -f1 | sort | jq -s max)
M16_DIFF=$(awk "BEGIN {print $M16_MAX - $M16_MIN}")

M17_MIN=$(echo "$M17" | cut -d ',' -f2 | cut -d ']' -f1 | sort | jq -s min)
M17_MAX=$(echo "$M17" | cut -d ',' -f2 | cut -d ']' -f1 | sort | jq -s max)
M17_DIFF=$(awk "BEGIN {print $M17_MAX - $M17_MIN}")

M18_MIN=$(echo "$M18" | cut -d ',' -f2 | cut -d ']' -f1 | sort | jq -s min)
M18_MAX=$(echo "$M18" | cut -d ',' -f2 | cut -d ']' -f1 | sort | jq -s max)
M18_DIFF=$(awk "BEGIN {print $M18_MAX - $M18_MIN}")

M19_MIN=$(echo "$M19" | cut -d ',' -f2 | cut -d ']' -f1 | sort | jq -s min)
M19_MAX=$(echo "$M19" | cut -d ',' -f2 | cut -d ']' -f1 | sort | jq -s max)
M19_DIFF=$(awk "BEGIN {print $M19_MAX - $M19_MIN}")

M20_MIN=$(echo "$M20" | cut -d ',' -f2 | cut -d ']' -f1 | sort | jq -s min)
M20_MAX=$(echo "$M20" | cut -d ',' -f2 | cut -d ']' -f1 | sort | jq -s max)
M20_DIFF=$(awk "BEGIN {print $M20_MAX - $M20_MIN}")

DIF_STR=("$M15_DIFF $M16_DIFF $M17_DIFF $M18_DIFF $M19_DIFF $M20_DIFF")
MIN_VOL=$(for x in $DIF_STR
do
   echo $x
done | jq -s min)

[ $MIN_VOL == $M15_DIFF ] && echo "2015 March was least volatile: $MIN_VOL"
[ $MIN_VOL == $M16_DIFF ] && echo "2016 March was least volatile: $MIN_VOL"
[ $MIN_VOL == $M17_DIFF ] && echo "2017 March was least volatile: $MIN_VOL"
[ $MIN_VOL == $M18_DIFF ] && echo "2018 March was least volatile: $MIN_VOL"
[ $MIN_VOL == $M19_DIFF ] && echo "2019 March was least volatile: $MIN_VOL"
[ $MIN_VOL == $M20_DIFF ] && echo "2020 March was least volatile: $MIN_VOL"

