#!/bin/bash
export PROJECTNAME=$1
export PROJECTHOME=$HOME/Kode/Projects/$1

if [ -d "$PROJECTHOME" ]; then
	# Control will enter here if $PROJECTHOME exists.
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
	for i in $(find . -type f -iregex '.*\.\(py\|sh\|sql\|erl\)' -printf '%T@ %p\n' | sort -n | tail -5 | cut -f2- -d" "); do
		subl $i
	done
	# Check if there is a project quickstart command file and execute
	if [ -f "$PROJECTHOME/.qs_commands" ]; then
		while read p; do
			gnome-terminal -e "$p"
		done < $PROJECTHOME/.qs_commands
	fi
else
	echo "Unknown project: $1"
fi