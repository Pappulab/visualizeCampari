#!/usr/bin/python

##=========================================================================================================
##				OOI: OpenOffice Interface to Python
##
##		This provides some simple functions for integrating with OpenOffice
##
##---------------------------------------------------------------------------------------------------------
##!!!!!!!!!!!!!!!!!!!!!!!!Before using this, run the line below on the commandline!!!!!!!!!!!!!!!!!!!!!!!!!
##
## soffice --nologo --nodefault --accept="socket,host=localhost,port=2002;urp;StarOffice.ServiceManager"&
##
##---------------------------------------------------------------------------------------------------------
##			To close everything safely, run the line below after finishing
##
##	soffice --unaccept="socket,host=localhost,port=2002;urp;StarOffice.ServiceManager"&
##
##
##	Ian Harvey
##	Pappu Lab
##	May 2014
##=========================================================================================================

import uno						#main import for using OpenOffice
from com.sun.star.beans import PropertyValue		#for setting properties: 'hidden'

##---------------------------------------------------------------------------------------------------------
# Generates a new document of a specified type
def newDoc(docType='swriter', hidden = True):
	
	# Make sure the docType argument is openable by OpenOffice
	enumList = ['swriter','simpress','scalc','sdraw','smath']
	if not docType in enumList:
		from difflib import get_close_matches
		docType = get_close_matches(docType,enumList,1)[0]
		if len(docType)==0:
			print '[FATAL ERROR]: Could not find the desired type of document'
			exit()
	
	# Start talking to OpenOffice
	local = uno.getComponentContext()   
	resolver = local.ServiceManager.createInstanceWithContext("com.sun.star.bridge.UnoUrlResolver", local)
	context = resolver.resolve( "uno:socket,host=localhost,port=2002;urp;StarOffice.ServiceManager" )
	remoteContext = context.getPropertyValue( "DefaultContext" )
	desktop = context.createInstanceWithContext( "com.sun.star.frame.Desktop",remoteContext)
	
	# Initialize the properties attribute
	properties = ()
	
	if hidden:
		#Generate a 'hidden' property
		p=PropertyValue()
		p.Name = 'Hidden'
		p.Value = True
		properties = (p,)
		
	# Open the new document
	document = desktop.loadComponentFromURL( "private:factory/"+docType,"_blank", 0, properties )
	return document

##---------------------------------------------------------------------------------------------------------	
# Imports a file to read in OpenOffice
#	-->CSV to OpenOffice::Calc
def loadDoc(infile):
	local = uno.getComponentContext()
	resolver = local.ServiceManager.createInstanceWithContext("com.sun.star.bridge.UnoUrlResolver", local)
	context = resolver.resolve("uno:socket,host=localhost,port=2002;urp;StarOffice.ComponentContext")
	desktop = context.ServiceManager.createInstanceWithContext("com.sun.star.frame.Desktop",context)
	
	#Generate a 'hidden' property
	p=PropertyValue()
	p.Name = 'Hidden'
	p.Value = True
	properties = (p,)
	
	# Try to open the file specified
	try:
		document = desktop.loadComponentFromURL("file://"+infile , "_blank", 0, properties)
	except __main__.CannotConvertException:
		print "[FATAL ERROR]: Unable to convert " + str(infile) + " into a readable format."
		exit()
	return document

##---------------------------------------------------------------------------------------------------------
# Exports the given document to the given filename
# Outfile must be a fullpath of the filename
def save(document, outfile, bool_overwrite = True):
	p = PropertyValue()
	p.Name = 'Overwrite'
	p.Value = bool_overwrite
	properties = (p,)
	document.storeAsURL('file://' + outfile, properties)
	
##---------------------------------------------------------------------------------------------------------
# Removes a chart if it exists in the list of charts
def removeChart(rName, charts):
	total = charts.getCount()
	for i in range(total):
		aChart = charts.getByIndex(i)
		if aChart.getName()== rName:
			charts.removeByName(rName)
			return True
	return False

##---------------------------------------------------------------------------------------------------------
# Given a bunch of parameters, generate a chart in scalc
def generateChart(sheetObj,sheetIndex, ID, rWidth, rHeight, rX, rY, 
		  startCol, startRow, endCol, endRow, colHeader=False, rowHeader=False):
	
	from com.sun.star.awt import Rectangle			# for specifying size & position
	from com.sun.star.table import CellRangeAddress 	# for specifying cells to graph
	
	# Selecting data range to process
	cr = CellRangeAddress(sheetIndex, startCol, startRow, endCol, endRow)
	dataRange = []
	dataRange.append(cr)
	
	# Size of the graph
	rect = Rectangle(rX,rY,rWidth,rHeight)
	
	# Generating the chart
	charts = sheetObj.getCharts()
	# If a chart with this name exists, delete it
	removeChart('chart'+ str(ID), charts)
	charts.addNewByName('chart'+ str(ID), rect, tuple(dataRange), colHeader, rowHeader)
	return charts.getByName('chart'+ str(ID))

##---------------------------------------------------------------------------------------------------------
# 1) Adds a new slide to a impress document 
# 2) Sets the title of a slide 
# 3) Sets a given picture in the major frame
def picNextSlide(doc, strTitle, inPicFile):
	from com.sun.star.awt import Size, Point
	
	if 'file://' not in inPicFile:
		inPicFile = 'file://'+str(inPicFile)
	
	# Array of DrawPages
	dpArr = doc.DrawPages
	lastPage = dpArr.insertNewByIndex(dpArr.Count - 1)
	# Change the page layout to have a title
	lastPage.Layout = 19L
	
	# Add a title to the slide
	titleObj = lastPage.getByIndex(0)
	titleObj.setString(strTitle)
	
	# ---------------Determine the optimal size for the graphic------------------
	# Add the same gap above the title underneath the title (before the graphic)
	yPos = 2*titleObj.Position.Y + titleObj.Size.Height
	# Set the height of the graphic so there is the same gap at the bottom of the slide
	gHeight = lastPage.Height - yPos - titleObj.Position.Y
	# Maintain proper aspect ratio generated in Matlab
	gWidth = (1280./860.)*gHeight
	# Center the graphic
	xPos = (lastPage.Width - gWidth)/2
	
	# Create the graphic object
	graphicObj = doc.createInstance('com.sun.star.drawing.GraphicObjectShape')
	graphicObj.Size = Size(gWidth, gHeight)
	graphicObj.Position = Point(xPos, yPos)
	graphicObj.GraphicURL = inPicFile
	
	# Add the graphic object
	lastPage.add(graphicObj)
	
##---------------------------------------------------------------------------------------------------------
# Ruthlessly sets the title of the document
# 1) Delete all content on the first slide
# 2) Add the desired title and body
def titleFirst(doc, strTitle, strBody):
	pages = doc.DrawPages
	first = pages.getByIndex(0)
	while(first.Count>0):
		first.remove(first.getByIndex(0))
	first.Layout = 0
	title = first.getByIndex(0)
	title.setString(strTitle)
	body = first.getByIndex(1)
	body.setString(strBody)
	
##=========================================================================================================
##			"Main Script - Hold onto your hat!"  -Alex Holehouse
##=========================================================================================================

if __name__=="__main__":
	import argparse
	
	# Parsing the input arguments
	parser = argparse.ArgumentParser(prog="OpenOffice Interface with Python", 
				  description="This provides some base functionality for interfacing with OpenOffice")
	
	parser.add_argument('--filename',	'-f', 	help="Name of the file to be processed") 
	parser.add_argument('--output',		'-o',	help="Name of the file to be output")
	
	args = parser.parse_args()
	
	