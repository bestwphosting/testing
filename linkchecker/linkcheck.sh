#!/bin/bash
set -Eeo pipefail
HOST="$1"
PAGE="$2"
LOOPS=10
SLEEP=30

TEMP_PAGE=${HOST}.html

[ -z "$PAGE" ] && PAGE="/ecuador-language-tips-learn-before-you-go-large/"
CURL_HEADERS_INDEX=(-H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*")
CURL_HEADERS_UA=(-H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36" --max-time 5)

function validate() {
	if [[ "$1" =~ ^/[^/] ]] || [[ "$1" =~ "$HOST" ]] || ([[ "$1" =~ ^[^/] ]] && [[ ! "$1" =~ ^http ]] && [[ "$1" =~ [\.\/] ]]); then
		if [[ ! "$1" =~ '/?p=' ]] && [[ ! "$1" =~ 'xmlrpc' ]] && [[ ! "$1" =~ '/wp-json' ]] && [[ ! "$1" =~ ^data: ]] ; then
			TEST_URLS+=("$1");
		fi
	fi
}

function xmlgrep() {
	echo $XML | xmlstarlet sel -t -v "$1"
}

for i in `seq 1 $LOOPS`; do
	rm -f $TEMP_PAGE
	set +e
	CURL=$(curl -s -o $TEMP_PAGE "${CURL_HEADERS_INDEX[@]}" "${CURL_HEADERS_UA[@]}" "https://${HOST}${PAGE}?$RANDOM")
	set -e
	XML=$(cat $TEMP_PAGE | xmlstarlet format -H - 2>/dev/null)
	BAD_URLS=()
	TEST_URLS=()
	CODES=()
	unset CONTENT_TYPE
	declare -A CONTENT_TYPE
	for thing in $(xmlgrep '//link/@href') $(xmlgrep '//script/@src') $(xmlgrep '//img/@src') $(xmlgrep '//img/@srcset') $(xmlgrep 'substring-after(//div/@style, "background-image:")' | awk -F"'" '{print $2;}') $(xmlgrep 'substring-after(//a/@style, "background-image:")' | awk -F"'" '{print $2;}'); do
		validate $thing
	done
	
	echo "TEST_URLS: ${TEST_URLS[@]}"
	
	for url in "${TEST_URLS[@]}"; do
		if [[ "$url" =~ ^//$HOST ]]; then
			url="https:${url}"
		elif [[ "$url" =~ ^/ ]]; then
			url="https://${HOST}${url}"
		elif [[ "$url" =~ ^[^/] ]] && [[ ! "$url" =~ ^http ]]; then
			url="https://${HOST}/${url}"
		fi

		extension=$(echo $url | cut -d'?' -f1 | rev | cut -d'.' -f1 | rev)
		case $extension in
		gif | png | jpg | jpeg | webp)
			CURL_HEADERS=(-H "Accept: image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8")
		;;
		css)
			CURL_HEADERS=(-H "Accept: text/css,*/*;q=0.1")
		;;
		*)
			CURL_HEADERS=(-H "Accept: */*")
		;;
		esac

		read -r code type <<< $(curl "${CURL_HEADERS[@]}" "${CURL_HEADERS_UA[@]}" --head -w "%{http_code} %{content_type}" -o /dev/null -s "$url"); 
		echo "$url $code $type";
		type=$(echo $type | awk -F',' '{print $1}' | awk -F"/" '{print $2}' | awk -F"[^[:alpha:]]" '{print $1}')

		if [ "$code" == "200" ]; then 
	        	CODES[$code]+="${url},"
			CONTENT_TYPE[$type]+="${url},"
		else
			BAD_URLS+=("$url $code");
		fi; 
	done
	echo "BAD: ${BAD_URLS[@]}"

	for key in "${!CODES[@]}"; do
		count=$(echo ${CODES[$key]} | echo $(( $(awk -F',' '{print NF}') - 1)));
		echo $key $count ${CODES[$key]};
	done

	echo "CONTENT_TYPE: ${!CONTENT_TYPE[@]}"
	for key in "${!CONTENT_TYPE[@]}"; do
		count=$(echo ${CONTENT_TYPE[$key]} | echo $(( $(awk -F',' '{print NF}') - 1)))
		echo $key $count ${CONTENT_TYPE[$key]};
	done

	[ "$i" != $LOOPS ] && echo "[${i}/${LOOPS}] Sleeping..." && sleep $SLEEP
done
