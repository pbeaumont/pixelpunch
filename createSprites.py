#!/usr/bin/python
from subprocess import call
import sys, getopt

#this isn't going to work since the frames of the uppercut randomly change size
#need to create our own list of widths and offsets so that is increments xoffset more sensibly

def main(argv):
	try:
		opts, args = getopt.getopt(argv,"s:c:")
	except getopt.GetoptError:
	    print 'createSprites.py -c <character> -s <setYouWant>'
	    sys.exit(2)

	for opt, arg in opts:
		if opt == "-s":
			setYouWant=arg
		elif opt == "-c":
			characterYouWant=arg

	folderName=characterYouWant+setYouWant+".atlas"
	call(["rm","-r",folderName])
	call(["mkdir",folderName])

	backgroundColor=''
	filename=""
	if characterYouWant == 'sketch':
		backgroundColor='2D678B'
		filename='sketch.gif'
		if setYouWant == "idle":
			spriteBottom=90
			startingXOffset=0
			spriteHeights=[73,74,75,74]
			spriteWidths=[56,57,57,57]
			spriteGaps=[9,10,10,7]
			
		elif setYouWant == "uppercut":
			spriteBottom=378
			startingXOffset=0
			spriteHeights=[57,48,68,91,93]
			spriteWidths=[51,57,74,84,62]
			spriteGaps=[21,8,9,5,13]

		elif setYouWant == "rollingThunder":
			spriteBottom=738
			startingXOffset=0
			spriteHeights=[62,67,85,85,86,94]
			spriteWidths=[55,51,65,72,62,82]
			spriteGaps=[12,21,18,20,16,22]

		elif setYouWant == "normalpunch":
			spriteBottom=278
			startingXOffset=0
			spriteHeights=[63,65,66]
			spriteWidths=[63,98,66]
			spriteGaps=[10,8,5]

		elif setYouWant == "block":
			spriteBottom=2710
			startingXOffset=0
			spriteHeights=[72,72]
			spriteWidths=[49,49]
			spriteGaps=[26,15]

		elif setYouWant == "hit":
			spriteBottom=2709
			startingXOffset=169
			spriteHeights=[74,83]
			spriteWidths=[62,67]
			spriteGaps=[0,11]
	elif characterYouWant=="gravis":
		backgroundColor='FA00FF'
		filename='Gravis.png'
		if setYouWant == 'idle':
			spriteBottom=88
			startingXOffset=0
			spriteHeights=[76,77,77,77]
			spriteWidths=[60,61,59,59]
			spriteGaps=[9,13,7,8]

	numOfSprites=len(spriteWidths)
	for x in range(0,numOfSprites):
		startingXOffset=startingXOffset+spriteGaps[x]
		spriteWidth=spriteWidths[x]
		spriteHeight=spriteHeights[x]
		yoffset=spriteBottom-spriteHeight
		call(["convert",filename,"-crop",str(spriteWidth)+"x"+str(spriteHeight)+"+"+str(startingXOffset)+"+"+str(yoffset),'-fuzz','7%','-transparent','#'+backgroundColor,folderName+"/"+characterYouWant+str(x)+"~iphone.png"])
		startingXOffset=startingXOffset+spriteWidth

if __name__ == "__main__":
   main(sys.argv[1:])
