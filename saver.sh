#! /bin/bash

Topic_ID=1
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
	if [[ $result==="Not Found"  ]]; then
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
		pageCount=2	
		while [ $pageCount -le $(get_pageCount) ]
		do
	
			echo "Save Topic $Topic_ID / Page $pageCount"
			get_topic $Topic_ID $pageCount
			echo $result > ./$dir/Topic_$Topic_ID\_$pageCount.json
			pageCount=$(( $pageCount + 1 ))
			
		done

	
	fi	
}


function main {
	check_env
	
	while true
	do
		echo "Get topic $Topic_ID"
		get_topic $Topic_ID
		
		if topicFound ; then
			save_topic	
			Topic_ID=$(( $Topic_ID + 1 ))
		else
		    

		    if [[ $retry_Count -le 10  ]]; then
			    echo "Topic "$Topic_ID" not found, keep trying ("$retry_Count"/10)"
			    retry_Count=$(( $retry_Count + 1 ))
			    Topic_ID=$(( $Topic_ID + 1 ))
		    else
			    echo "Done!"
			    exit 0
		    fi

		fi
	done

}

main
