#!/bin/bash
export PROJECTNAME=$1
export PROJECTHOME=/home/morten/Kode/Projects/$1

if [ -d "$PROJECTHOME" ]; then
	# Control will enter here if $PROJECTHOME exists.
	echo $PROJECTNAME
	echo $PROJECTHOME
else
	echo "Unknown project: $1"
fi