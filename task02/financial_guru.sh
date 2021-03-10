#!/bin/bash
curl -s https://yandex.ru/news/quotes/graph_2000.json > ./quotes.json
DATE_VAL_TUPLE=$(jq '.prices[][0] |= ( . /1000 | strftime("%Y-%b-%d"))' quotes.json | 
jq -c '.prices[]')

ALL_MON=$(printf "%02d/01/2000\n" {1..12} | LC_ALL=C date +%b -f-)

VOL () {
# default values
[ -z $1 ] && START_YEAR='2015' || START_YEAR=$1
[ -z $2 ] && END_YEAR='2021' || END_YEAR=$2
[ -z $3 ] && MONTH='Feb' || MONTH=$3

# check Month format
CHECK=$(echo "$ALL_MON" | grep $MONTH)
if [ -z $CHECK ]
then
   echo "Error: month must be specified in abbreviate format. Examle: Feb, Jan, Mar.s" > /dev/stderr
   exit 1
else 
   MONTH=$(echo "$CHECK" | head -1)
fi

[[ $START_YEAR < '2015' ]] && echo "Error: year must start from 2015" > /dev/stderr && exit 1
[[ $END_YEAR > '2021' ]] && echo "Error: year must end at 2021" > /dev/stderr && exit 1

if [[ $END_YEAR == '2021' ]] && [[ $MONTH != 'Jan' ]] && [[ $MONTH != 'Feb' ]]
then
   echo "Error: no data after 02.2021" > /dev/stderr
   exit 1
fi

for i in $(seq $START_YEAR $END_YEAR)
do
   MIN=$(echo "$DATE_VAL_TUPLE" | grep "$i"-"$MONTH" | cut -d, -f2 | cut -d] -f1 | jq -s min)
   MAX=$(echo "$DATE_VAL_TUPLE" | grep "$i"-"$MONTH" | cut -d, -f2 | cut -d] -f1 | jq -s max)
   DIFF=$(awk "BEGIN {print ($MAX - $MIN)/2} ")
   echo $MONTH $i "volatility is" $DIFF > /dev/tty
   echo $MONTH $i "is the least volatile:" $DIFF
done
echo "======================================" > /dev/tty

}
echo "$(VOL $1 $2 $3)" | awk 'NR == 1 { j = $0; min = $7 } NR > 1 && $7 < min { j = $0; min = $7 } END { print j ; }'

echo "======================================"

























# M15=$(echo "$DATE_VAL_TUPLE" | grep '2015-03')
# M16=$(echo "$DATE_VAL_TUPLE" | grep '2016-03')
# M17=$(echo "$DATE_VAL_TUPLE" | grep '2017-03')
# M18=$(echo "$DATE_VAL_TUPLE" | grep '2018-03')
# M19=$(echo "$DATE_VAL_TUPLE" | grep '2019-03')
# M20=$(echo "$DATE_VAL_TUPLE" | grep '2020-03')

# M15_MIN=$(echo "$M15" | cut -d ',' -f2 | cut -d ']' -f1 | sort | jq -s min)
# M15_MAX=$(echo "$M15" | cut -d ',' -f2 | cut -d ']' -f1 | sort | jq -s max)
# M15_DIFF=$(awk "BEGIN {print $M15_MAX - $M15_MIN}")

# M16_MIN=$(echo "$M16" | cut -d ',' -f2 | cut -d ']' -f1 | sort | jq -s min)
# M16_MAX=$(echo "$M16" | cut -d ',' -f2 | cut -d ']' -f1 | sort | jq -s max)
# M16_DIFF=$(awk "BEGIN {print $M16_MAX - $M16_MIN}")

# M17_MIN=$(echo "$M17" | cut -d ',' -f2 | cut -d ']' -f1 | sort | jq -s min)
# M17_MAX=$(echo "$M17" | cut -d ',' -f2 | cut -d ']' -f1 | sort | jq -s max)
# M17_DIFF=$(awk "BEGIN {print $M17_MAX - $M17_MIN}")

# M18_MIN=$(echo "$M18" | cut -d ',' -f2 | cut -d ']' -f1 | sort | jq -s min)
# M18_MAX=$(echo "$M18" | cut -d ',' -f2 | cut -d ']' -f1 | sort | jq -s max)
# M18_DIFF=$(awk "BEGIN {print $M18_MAX - $M18_MIN}")

# M19_MIN=$(echo "$M19" | cut -d ',' -f2 | cut -d ']' -f1 | sort | jq -s min)
# M19_MAX=$(echo "$M19" | cut -d ',' -f2 | cut -d ']' -f1 | sort | jq -s max)
# M19_DIFF=$(awk "BEGIN {print $M19_MAX - $M19_MIN}")

# M20_MIN=$(echo "$M20" | cut -d ',' -f2 | cut -d ']' -f1 | sort | jq -s min)
# M20_MAX=$(echo "$M20" | cut -d ',' -f2 | cut -d ']' -f1 | sort | jq -s max)
# M20_DIFF=$(awk "BEGIN {print $M20_MAX - $M20_MIN}")

# DIF_STR=("$M15_DIFF $M16_DIFF $M17_DIFF $M18_DIFF $M19_DIFF $M20_DIFF")
# MIN_VOL=$(for x in $DIF_STR
# do
#    echo $x
# done | jq -s min)

# [ $MIN_VOL == $M15_DIFF ] && echo "2015 March was least volatile: $MIN_VOL"
# [ $MIN_VOL == $M16_DIFF ] && echo "2016 March was least volatile: $MIN_VOL"
# [ $MIN_VOL == $M17_DIFF ] && echo "2017 March was least volatile: $MIN_VOL"
# [ $MIN_VOL == $M18_DIFF ] && echo "2018 March was least volatile: $MIN_VOL"
# [ $MIN_VOL == $M19_DIFF ] && echo "2019 March was least volatile: $MIN_VOL"
# [ $MIN_VOL == $M20_DIFF ] && echo "2020 March was least volatile: $MIN_VOL"

