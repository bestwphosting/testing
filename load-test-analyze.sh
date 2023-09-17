#!/bin/bash -ex

DIR=$1
HOST=$(basename $1)
OUTPUT_FILE=${HOST}.csv

echo "region,http_req_duration_min,http_req_duration_max,http_req_duration_avg,http_req_failed_rate" > $OUTPUT_FILE
shopt -s nullglob
for file in $DIR/*; do
	FILENAME=$(basename $file)
	VERSION=$(echo $FILENAME | cut -d'-' -f1)
	REGION=$(echo $FILENAME | cut -d'-' -f4- | cut -d'.' -f1)
	DURATION_MIN=
	DURATION_MAX=0
	DURATION_TOTAL=0
	durations=()
	fails=()

	echo "FILE: $file"
	echo "FILENAME: $FILENAME VERSION: $VERSION REGION: $REGION HOST: $HOST"
	echo

	while IFS="," read -r f1 f2
	do
		if [ "$f1" == "http_req_duration" ]; then
			[ -z $DURATION_MIN ] || (( $(echo "$f2 < $DURATION_MIN" | bc -l) )) && DURATION_MIN=$f2
			(( $(echo "$f2 > $DURATION_MAX" | bc -l) )) && DURATION_MAX=$f2
			durations+=($f2)
			DURATION_TOTAL=$(awk "BEGIN {print $DURATION_TOTAL + $f2; exit}")  # $(echo $DURATION_TOTAL + $f2 | bc )
		elif [ "$f1" == "http_req_failed" ] && [ "$f2" == 1 ]; then
			fails+=($f2)
		fi
	done < <(cut -d "," -f1,3 $file | tail -n +2)

	DURATION_AVG=$(awk "BEGIN {print $DURATION_TOTAL / ${#durations[@]}; exit}")
	FAILURE_RATE=$(awk "BEGIN {print (${#fails[@]} / ${#durations[@]}) * 100; exit}") 
	echo "DURATION:"
	echo "min $DURATION_MIN"
	echo "max $DURATION_MAX"
	echo "avg $DURATION_AVG"
	echo
	echo "FAILURE:"
	echo "${FAILURE_RATE}%"

	echo "$REGION,$DURATION_MIN,$DURATION_MAX,$DURATION_AVG,$FAILURE_RATE" >> $OUTPUT_FILE
done
mv $OUTPUT_FILE ${VERSION}-${HOST}-loadtest-results.csv
