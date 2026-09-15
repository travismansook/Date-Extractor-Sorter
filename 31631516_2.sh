#!/bin/bash

# Non-recursive method.
file="$1" #queue array at 0 index is testdir
original_date=()
sort_key=()

if [ $# -gt 1 ]; then
	echo "too many arguments"
elif [ $# -eq 1 ]; then

	while IFS= read -r line; do
		match=$(echo "$line" | grep -oE '[0-9]{2}[./-][0-9]{2}[./-][0-9]{4}')
		if [ -n "$match" ]; then
			for date in $match; do
				original_date+=("$date")
				if echo "$date" | grep -q '\.'; then
					year=$(echo "$date"  | sed 's/\./ /g' | cut -d' ' -f3)
					month=$(echo "$date" | sed 's/\./ /g' | cut -d' ' -f1)
					day=$(echo "$date"   | sed 's/\./ /g' | cut -d' ' -f2)
				elif echo "$date" | grep -q '/'; then
					year=$(echo "$date"  | cut -d'/' -f3)
                                        month=$(echo "$date" | cut -d'/' -f1)
                                        day=$(echo "$date"   | cut -d'/' -f2)
				else
					year=$(echo "$date"  | cut -d'-' -f3)
                                        month=$(echo "$date" | cut -d'-' -f1)
                                        day=$(echo "$date"   | cut -d'-' -f2)
				fi
				key="${year}${month}${day}"
				sort_key+=("$key")
			done
		fi
	done < "$file"
	i=0
	length=${#original_date[@]}

	while [ $i -lt "$length" ]; do
		echo "${sort_key[$i]}|${original_date[$i]}"
		i=$((i+1))
	done | sort -t '|' -k1,1 | cut -d '|' -f2
else
	echo "invalid"
fi
