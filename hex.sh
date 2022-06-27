#!/bin/bash
# hex.sh
# Andrew Barlow

# DESCRIPTION
# A shell script to mess w/ a picture's hex values

# RESOURCES
# made much more user friendly with help from:
# https://stackabuse.com/how-to-parse-command-line-arguments-in-bash/

# OPTIONS
# file
# corruption-rate
# help


SHORT=f:,r:,h
LONG=file:,rate,help
OPTS="$(getopt --options $SHORT --longoptions $LONG -- $@ )"

# display options
help() {
	echo "Options:"
	echo "-f (--file) <file> 	| define source image"
	echo "-r (--rate) <rate> 	| set image corruption rate"
	echo "-h (--help) 		| display help"
}

# Returns the count of arguments that are in short or long options
VALID_ARGUMENTS=$# 

if [ "$VALID_ARGUMENTS" -eq 0 ]; then
  help
fi

eval set -- "$OPTS"

# parse arguments
while :
do
	case "$1" in
		-f | --file )
			file="$2"
			shift 2
		;;
		-r | --rate )
			rate="$2"
			shift 2
		;;
		-h | --help )
			help
			exit 2
		;;
	--)
		shift;
		break
		;;
	*)
		echo "Unexpected option: $1"
		;;
	esac
done

if [ "$file" ] && [ "$rate" ]
then
	# get hex content of file
	hex="$(hexdump $file)"

	# TODO figure out why my edits r breaking png format

	# POTENTIAL FIX - but still not recognized :(
	# https://stackoverflow.com/questions/7826526/transform-hexadecimal-information-to-binary-using-a-linux-command
	# xxd -r -p hex output.png

fi
