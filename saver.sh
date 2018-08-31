#! /bin/bash

if [[ $URL == '' ]];
then
	echo 'You have to set $URL first.'
	echo "\$ export URL='https://example.com' "
	exit 1
fi

if [[ $Cookies == '' ]];
then
	echo 'You have to set $Cookies first.'
	echo "\$ export Cookies='express.sid=\"s:YOURCOOKIES\"' "
	exit 2 
fi

