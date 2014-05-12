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
# Start up the OpenOffice port
soffice --nologo --nodefault --accept="socket,host=localhost,port=2002;urp;StarOffice.ServiceManager"&

if [[ -d $1 ]]; then	
	# Get the absolute path to the directory
	ABSPATH="$(cd ${1%/*}; pwd)/${1##*/}"
	
	# Graph all data desired
	matlab -nosplash -nodesktop -r "graphCampari('$ABSPATH');"
	
	# Generate a presentation of this data
	python presentCampari.py -d $ABSPATH
else
	echo "$1 is not a directory."
	exit 1
fi

# Close the OpenOffice port
soffice --unaccept="socket,host=localhost,port=2002;urp;StarOffice.ServiceManager"&