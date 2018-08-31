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

function main() {
	check_env
}

main
