#!/bin/bash
export PROJECTNAME=$1
export PROJECTHOME=/home/morten/Kode/Projects/$1

if [ -d "$PROJECTHOME" ]; then
	# Control will enter here if $PROJECTHOME exists.
	echo $PROJECTNAME
	echo $PROJECTHOME
	# Go to projecthome and find all script files
	cd $PROJECTHOME
	# Start a gnome-terminal in the projecthome
	gnome-terminal
	# If project home contains a bin directory open a gnome-terminal there as well
	if [ -d "$PROJECTHOME/bin" ]; then
		cd $PROJECTHOME/bin
		gnome-terminal --working-directory=$PROJECTHOME/bin
	fi
	# Start up sublime text in a seperate instance
	subl -n
	# Open the last 5 modified files in subl
	# -iregex '.*\.\(py\|sh\|erl\)'
	# find . -type f -iregex '.*\.\(py\|sh\|erl\)' -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" "
	for i in $(find . -type f -iregex '.*\.\(py\|sh\|erl\)' -printf '%T@ %p\n' | sort -n | tail -5 | cut -f2- -d" "); do
		subl $i
	done
else
	echo "Unknown project: $1"
fi