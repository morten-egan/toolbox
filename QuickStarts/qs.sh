#!/bin/bash
export PROJECTNAME=$1
export PROJECTHOME=$HOME/Kode/Projects/$1
PATH=$PROJECTHOME/bin:$PROJECTHOME/lib:$PATH

if [ -d "$PROJECTHOME" ]; then
	# Control will enter here if $PROJECTHOME exists.
	# Go to projecthome and find all script files
	cd $PROJECTHOME
	# Check and set environment before starting terminals and programs
	if [ -f "$PROJECTHOME/.qs_env" ]; then
		while read p; do
			export $p
		done < $PROJECTHOME/.qs_env
	fi
	# Start a gnome-terminal in the projecthome
	gnome-terminal
	# If project home contains a bin directory open a gnome-terminal there as well
	if [ -d "$PROJECTHOME/bin" ]; then
		cd $PROJECTHOME/bin
		gnome-terminal --working-directory=$PROJECTHOME/bin
	fi
	cd $PROJECTHOME
	# Open the last 5 modified files in subl
	flist="$PROJECTHOME/README.md"
	for i in $(find . -type f -iregex '.*\.\(py\|sh\|pks\|pkb\|sql\|erl\|tpl\|html\|js\)' -printf '%T@ %p\n' | sort -n | tail -5 | cut -f2- -d" "); do
		flist="$flist $i"
	done
	# Check if a sublime project file exists. If it does open that, else open last modified filelist
	PROJECT=`ls *.sublime-project 2>/dev/null`
	if [ -e "$PROJECT" ]; then
		# Sublime project exists - open that
		subl . --project "$PROJECT"
	else
		# No project file, open modified filelist
		subl -n $flist
	fi
	# Check if there is a project quickstart command file and execute
	if [ -f "$PROJECTHOME/.qs_commands" ]; then
		gnome-terminal -e "setsid bash .qs_commands"
	fi
else
	echo "Unknown project: $1"
fi
