#!/bin/ksh -p
#set -x
#

#Set IFS variable to only separate on tabs
IFS=$'\t'

#Create an array with the tab-delimited files passed from Alfred
filesFromAlfred=(`echo "$1"`)

#Loop through each file in the array
for file in ${filesFromAlfred[@]}
do
	IFS=$'\n'
    #do something with the file
	filename=$(basename "$file")
	filedirname=$(dirname "$file")
	extension="${filename##*.}"
	filename="${filename%.*}"
	
	
	cp $file /tmp/tmp.$extension
	
	osascript converttopdf.applescript "/tmp/tmp.${extension}"
	if [ $? != 0 ]
	then
		if [ -f /tmp/tmp.${extension} ]
		then
			rm /tmp/tmp.${extension}
		fi
		echo "ERROR during conversion of $file"
		continue
	fi
	
	if [ -f /tmp/tmp.pdf ]
	then
		mv /tmp/tmp.pdf ${filedirname}/${filename}.pdf
		echo "${filedirname}/${filename}.pdf"
	fi
	
	if [ -f /tmp/tmp.${extension} ]
	then
		rm /tmp/tmp.${extension}
	fi
done

#Reset IFS to its original state
unset IFS

osascript <<EOT
tell application "Alfred 2" to search "${filedirname}/${filename}.pdf"
EOT

exit 0