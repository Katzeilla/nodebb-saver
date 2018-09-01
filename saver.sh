#! /bin/bash

Topic_ID=40
retry_Count=0
dir=$1

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

# get_topic <topic_ID> [<page_ID>]
# set $result to json response

function get_topic {
	if [[ $2 == ''  ]]; then
		result=$(curl -b $Saver_Cookies $Saver_URL/api/topic/$1)
	else
		result=$(curl -b $Saver_Cookies $Saver_URL/api/topic/$1?page=$2)
		
	fi

}


# return page count for $result

function get_pageCount {
	echo $result | jq .pagination.pageCount
}

function topicFound {
	if [[ $result==="Not Fount"  ]]; then
		false
	else
		true
	fi
}


# save_topic <Topic_ID>
# Save Json to disk

function save_topic {
	if [ ! -d $dir ]; then
		mkdir ./$dir  	
	fi

	echo $result > ./$dir/Topic_$Topic_ID.json

	if [[ $(get_pageCount) > 1  ]]; then 
	echo "LT 1"
	fi	
}


function main {
	check_env
#	get_topic 41	
#	get_pageCount
	
	while true
	do
		echo "Get topic $Topic_ID"
		get_topic $Topic_ID

		if [ topicFound ]; then
			save_topic	
			Topic_ID=$(( $Topic_ID + 1 ))
		else
		    if [[ $retry_Count -le 10  ]]; then
			    Topic_ID=$(( $Topic_ID + 1 ))
		    else
			    echo "Done!"
		    fi

		fi
	done

}

main
