#!/bin/bash -e
source .env
BASE_CURL="curl -s -u ${GTMETRIX_API_KEY}:"
BASE_API_URL=https://gtmetrix.com/api/2.0
HOST=$1
LOCATIONS_MOBILE=(9 11 6 21 2 15 22 5 17 3 7 18)

$BASE_CURL ${BASE_API_URL}/status

function run_test() {
	local location=$1
	local optimization=$2
	local type=$3

	local adtl_json
	local page

	get_url "$optimization"

	if [ "$type" == "mobile" ]; then
		adtl_json="\"throttle\": \"15000/10000/100\", \"simulate_device\": \"iphone_13\","
	fi

	echo "Requesting report for $HOST on $page OPT: $optimization TYPE: $type LOCATION: $location"
	local output=$($BASE_CURL -X POST -H Content-Type:application/vnd.api+json \
	    ${BASE_API_URL}/tests \
	    -d "
	{
	  \"data\": {
	    \"type\": \"test\",
	    \"attributes\": {
	      \"url\":      \"${URL}\",
	      \"location\": \"${location}\",
	      \"browser\":  \"3\",
	      \"report\":   \"lighthouse\",
	      \"retention\": 1,
	      \"adblock\":  0,
	      \"video\": 0,
	      ${adtl_json}
	      \"stop_onload\": 0
	    }
	  }
  	}")
	echo $output | jq .
	local test_link=$(echo $output | jq -r .links.self)
	[ "$test_link" == "null" ] && echo "Null test link. Giving up on this one." && return

	# Wait for report to finish
	local test_state=""
	while [ "$test_state" != "completed" ] && [ "$test_state" != "error" ]; do
		local test_output=$($BASE_CURL $test_link)
		local test_state=$(echo $test_output | jq -r .data.attributes.state)
		echo "Test state: $test_state"
		if [ "$test_state" == "completed" ]; then
			local report_link=$(echo $test_output | jq -r .data.links.report)
			local report_download=$($BASE_CURL $report_link | jq -r .data.links.report_pdf)
			$BASE_CURL -o ${HOST}-${type}-${optimization}-${location}-GTMetrix.pdf -L $report_download
			continue
		elif [ "$test_state" == "error" ]; then
			echo $test_output | jq -r .data.attributes.error
			continue
		fi
		sleep 5
	done
}

run_test 1 "unopt" "desktop" 
run_test 1 "opt" "desktop"
run_test 1 "unopt" "mobile"
run_test 1 "opt" "mobile"

for id in "${LOCATIONS_MOBILE[@]}"; do
       run_test $id "unopt" "mobile"
done       
