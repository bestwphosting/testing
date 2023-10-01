#!/bin/bash -e
source "${BASH_SOURCE%/*}/common"
BASE_API_URL=https://pagespeedonline.googleapis.com/pagespeedonline/v5/runPagespeed
HOST=$1
BASE_CURL="curl -s ${BASE_API_URL}"

function get_score() {
	jq -r $1 $2 
}

function run_test() {
	local optimization=$1
	local type=$2

	local page
	local output="$(datestamp)-${HOST}-${optimization}-${type}-PageSpeed.json"
	local scores=()

	get_url "$optimization"

	echo "Requesting report for $HOST on $page OPT: $optimization TYPE: $type"
	${BASE_CURL}?strategy=$type\&url=${URL} -o $output

	echo "FCP: " $(get_score '.lighthouseResult.audits."first-contentful-paint".score' $output) $(get_score '.lighthouseResult.audits."first-contentful-paint".displayValue' $output)
	echo "LCP: " $(get_score '.lighthouseResult.audits."largest-contentful-paint".score' $output) $(get_score '.lighthouseResult.audits."largest-contentful-paint".displayValue' $output)
	echo "TBT: " $(get_score '.lighthouseResult.audits."total-blocking-time".score' $output) $(get_score '.lighthouseResult.audits."total-blocking-time".displayValue' $output)
	echo "CLS: " $(get_score '.lighthouseResult.audits."cumulative-layout-shift".score' $output) $(get_score '.lighthouseResult.audits."cumulative-layout-shift".displayValue' $output)
	echo "SpeedIndex: " $(get_score '.lighthouseResult.audits."speed-index".score' $output) $(get_score '.lighthouseResult.audits."speed-index".displayValue' $output)
	echo "Performance: " $(get_score '.lighthouseResult.categories.performance.score' $output)
}

echo "Report time: $(datestamp)"
run_test opt mobile
run_test opt desktop
run_test unopt mobile
run_test unopt desktop
