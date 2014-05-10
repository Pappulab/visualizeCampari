#!/bin/bash

##==============================================================================
##			Campari Output Parsing Bash Script
##
##	Objective of this script: 
##		(1) Visualize most of Campari's output
##		(2) Generate an easily readable presentation 
##
##	 Argument $1: Directory of finished Campari output to parse
##
##	Ian Harvey
##	Pappu Lab
##	May 2014
##==============================================================================

if [[ -d $1 ]]; then
	# Graph all data desired
	matlab -nosplash -nodesktop -r "graphCampari('$1');"
	# Generate a presentation of this data
	python presentCampari.py -d $1
	
else
	echo "$1 is not a directory."
	exit 1
fi