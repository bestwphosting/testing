#!/bin/bash -ex
BASE_CURL="curl -s -u ${GTMETRIX_API_KEY}:"
BASE_API_URL=https://gtmetrix.com/api/2.0
HOST=$1
PAGE=$2
[ -z "$PAGE" ] && PAGE="/ecuador-language-tips-learn-before-you-go-large/"
LOCATIONS_DESKTOP=(1)
#LOCATIONS_MOBILE=(1 9 11 6 21 2 15 22 5 17 3 7 18)

$BASE_CURL ${BASE_API_URL}/status

for location in "${LOCATIONS_DESKTOP[@]}"; do
	output=$($BASE_CURL -X POST -H Content-Type:application/vnd.api+json \
	    ${BASE_API_URL}/tests \
	    -d "
	{
	  \"data\": {
	    \"type\": \"test\",
	    \"attributes\": {
	      \"url\":      \"https://${HOST}${PAGE}\",
	      \"location\": \"${location}\",
	      \"browser\":  \"3\",
	      \"report\":   \"lighthouse\",
	      \"retention\": 1,
	      \"adblock\":  0,
	      \"video\": 0,
	      \"stop_onload\": 0
	    }
	  }
  	}")
	echo $output | jq .
	test_link=$(echo $output | jq -r .links.self)
	[ "$test_link" == "null" ] && continue

	# Wait for report to finish
	test_state=""
	while [ "$test_state" != "completed" ] && [ "$test_state" != "error" ]; do
		test_output=$($BASE_CURL $test_link)
		test_state=$(echo $test_output | jq -r .data.attributes.state)
		if [ "$test_state" == "completed" ]; then
			report_link=$(echo $test_output | jq -r .data.links.report)
			report_download=$($BASE_CURL $report_link | jq -r .data.links.report_pdf)
			$BASE_CURL -o ${HOST}-${location}-report.pdf -L $report_download
			continue
		elif [ "$test_state" == "error" ]; then
			error=$(echo $test_output | jq -r .data.attributes.error)
			continue
		fi
		sleep 5
	done

done
