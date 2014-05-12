#!/usr/bin/python

##=========================================================================================================
##		presentCampari: Automated Presentation Generator for Campari Data
##
##			This will create a PPT file (by default)
##
##
##	Ian Harvey
##	Pappu Lab
##	May 2014
##=========================================================================================================

import ooi

# Simply put each file on it's own page in a presentation
def generateDocument(args):
	from datetime import datetime
	import os
	from os import listdir
	from os.path import isfile, join
	
	# Get the PNG files in the matlab directory
	try:
		dirFiles = [ f for f in listdir(args.directory) if isfile(join(args.directory,f)) ]
	except OSError:
		print '[FATAL ERROR]: The directory specified does not appear to contain Campari data processed by graphCampari.m'
		exit(1)
	
	# Create the document
	doc = ooi.newDoc('impress')
	
	# Set the title of the presentation and the body to the date 
	timeObj = datetime.now()
	strDate = str(timeObj.day)+'/'+timeObj.strftime("%B")+'/'+str(timeObj.year)
	ooi.titleFirst(doc, args.title, strDate)
	
	# If there are other types of files, don't use them
	pngFiles = []
	for f in dirFiles:
		if '.png' in f:
			pngFiles.append(f)
	
	for p in pngFiles:
		ooi.picNextSlide(doc,p[:p.find('.')],join(args.directory,p))
	
	# Get the full path of the parsedOutput_NOBKP directory
	os.chdir(args.directory)
	fullPath = os.path.abspath(dirFiles[0])
	fullPath = fullPath[:fullPath.find('matlab')]
	
	# Save the document
	ooi.save(doc, fullPath+args.output)
	
	# Exit clean up
	doc.dispose()
	
# ArgumentParserType for Impress Extensions that are available
def ImpressExtension(aFmt):
	allowed= ['ppt','odp','otp','odg','sxi','sti','sxd','fodp','uop'
	 ,'pptx','ppsx','potm','pps','pot']
	# Raise a value error if aFmt is not in the allowed list
	if not aFmt.lower() in allowed:
		raise argparse.ArgumentTypeError("Format must be an extension within OOImpress")
	else:
		return aFmt.lower()

if __name__=="__main__":
	import argparse
	
	# Basic description of presentCampari.py for the help
	parser = argparse.ArgumentParser(prog="presentCampari",
				  description="An Automatic Presentation Generator for Campari Data")
	# Directory desired
	parser.add_argument('--directory',	'-d',	help="Directory of the Campari output after running graphCampari.m", 									required=True)
	parser.add_argument('--format',		'-f',	help="Output format for the presentation",				default='ppt', 				type=ImpressExtension)
	parser.add_argument('--title',		'-t',	help="Title slide title text (Put in parentheses)", 			default='Visualized Campari Output')
	parser.add_argument('--output',		'-o',	help="Output presentation file name", 					default='Presentation.ppt')
	
	args = parser.parse_args()
	
	# If the user gave the parsedOutput directory inside a Campari,
	if '/parsedOutput_NOBKP/' in args.directory:
		# If the user gave the matlab directory inside parsedOutput/
		if not 'parsedOutput_NOBKP/matlab/' in args.directory:
			args.directory = directory[:directory.find('/parsedOutput_NOBKP/')+20]+'matlab/'
	# If the user gave their raw campari directory (assumed correct at this point)
	else:
		args.directory = args.directory + 'parsedOutput_NOBKP/matlab/'
	
	# Set the correct output format to the output name
	if not args.format in args.output:
		if '.' in args.output:
			aName = args.output[:args.output.find('.')]
		else:
			aName = args.output
		args.output = aName + '.' + args.format
	
	# Right now, only output the presentation to the parsedOutput_NOBKP folder
	if '/' in args.output:
		args.output = args.output[args.output.rfind('/')+1:]
	
	generateDocument(args)