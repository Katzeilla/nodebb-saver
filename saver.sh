#! /bin/bash

function check_env {
if [[ $Saver_URL == '' ]]; then
	echo 'Error: You have to set $Saver_URL first.'
	echo "\$ export Saver_URL='https://example.com' "
	exit 1
fi

if [[ $Saver_Cookies == '' ]]; then
	echo 'Error: You have to set $Saver_Cookies first.'
	echo "\$ export Saver_Cookies='express.sid=\"s:YOURCOOKIES\"' "
	exit 2 
fi


if ! [ -x "$(command -v jq)" ]; then
	  echo 'Error: jq is not installed.' >&2
	  exit 3
fi

if ! [ -x "$(command -v curl)" ]; then
	  echo 'Error: curl is not installed.' >&2
	  exit 4
fi

}

# get_topic <topic_ID>
# set $result to json response

function get_topic {
	result=$(curl -b $Saver_Cookies $Saver_URL/api/topic/$1)
}

# get_pageCount 
# return page count for $result

function get_pageCount {
	echo $result | jq .pagination.pageCount
}


function main {
	check_env
#	get_topic 41	
#	get_pageCount
	
	Topic_ID=1
	while true
	do
	echo "Get topic $Topic_ID"
	get_topic $Topic_ID
	echo $result | jq
	Topic_ID=$(( $Topic_ID + 1 ))
	done

}

main
