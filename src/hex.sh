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


SHORT=f:,h
LONG=file:,help
OPTS="$(getopt --options $SHORT --longoptions $LONG -- $@ )"

# display options
help() {
	echo "Options:"
	echo "-f (--file) <file> 	| define source image"
	# echo "-r (--rate) <rate> 	| set image corruption rate"
	echo "-h (--help) 		| display help"
}

# random_num min max
random_num() {
	local result="$((RANDOM % $2 + $1))"
	echo "$result"
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

if [ "$file" ]
then

	tmp="$(mktemp /tmp/hex.XXXXXX)"

	let i=0

	# get hex content of file, pipe to a line-by-line read loop
	hexdump $file |

	while read -r line; do

		let i++

		chance="$(random_num 0 100000)"

		if [ "$chance" -lt 5 ] && [ "$i" -gt 500 ]
		then
			echo "$(sed 's/0/1/' <<< $line)" >> "$tmp"
		else 
			echo "$line" >> "$tmp"
		fi

	done


	# TODO - handle extensions
	xxd -r -p "$tmp" output.jpg

	rm "$tmp"


fi
