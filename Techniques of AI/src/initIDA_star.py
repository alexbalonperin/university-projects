#!/usr/local/bin/python
# -*-coding:utf-8 -* 
#
#			'#' is a wall
#			'$' is a box
#			'o' is a goal
#			'X' is a dead zone 
#			' ' is a empty position
#			'&' is a placed box 
#

#	the map is a list



import math
from  printing import *

global width
expectedQuality = 20 #value between 0 and 100, 100 means that the program always tests if in the case 2 identical state if the second has a lower cost
#0 means that the second one is always rejected



map2 = [         '#', '#', '#', '#', '#', '#', '#', '#', '#', '#',
		'#', 'o', 'o', '#', '#', ' ', ' ', ' ', ' ', '#',
		'#', ' ', ' ', '#', '#', ' ', ' ', ' ', ' ', '#',
		'#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'o', '#',	
		'#', ' ', ' ', ' ', ' ', ' ', '#', '#', '#', '#',
		'#', ' ', '#', '#', '#', '$', ' ', ' ', ' ', '#',
		'#', ' ', ' ', '#', '#', ' ', ' ', ' ', ' ', '#',
		'#', ' ', ' ', '#', '#', ' ', ' ', ' ', '#', '#',
		'#', '$', ' ', ' ', '#', '$', ' ', ' ', '#', '#',
		'#', ' ', ' ', ' ', '#', ' ', ' ', '#', '#', '#',
		'#', '#', '#', '#', '#', '#', '#', '#', '#', '#'  ]

map1 = [         '#', '#', '#', '#', '#', '#', '#', '#', '#','#',
                '#', '#', ' ', ' ', ' ', ' ', ' ', '#', '#','#',
		'#', '#', '$', '#', '#', '#', ' ', ' ', ' ','#',
		'#', ' ', ' ', ' ', '$', ' ', ' ', '$', ' ','#',
                '#', ' ', 'o', 'o', '#', ' ', '$', ' ', '#','#',
		'#', '#', 'o', 'o', '#', ' ', ' ', ' ', '#','#',
		'#', '#', '#', '#', '#', '#', '#', '#', '#','#']


map3 = [         '#', '#', '#', '#', '#', '#', '#', '#', '#',
                '#', '#', '#', ' ', ' ', '#', '#', '#', '#',
		'#', ' ', ' ', ' ', ' ', ' ', '$', ' ', '#',
		'#', ' ', '#', ' ', ' ', '#', '$', ' ', '#',
		'#', ' ', 'o', ' ', 'o', '#', ' ', ' ', '#',
		'#', '#', '#', '#', '#', '#', '#', '#', '#' ]
			

map4 = [         '#', '#', '#', '#', '#', '#', '#', '#', '#', '#','#', '#','#', '#','#',
                '#', '#', '#', '#', '#', '#', '#', ' ', ' ', ' ',' ', ' ',' ', ' ','#',
		'#', '#', '#', '#', '#', '#', '#', ' ', '#', ' ','#', ' ','#', ' ','#', 
		'#', '#', '#', '#', '#', '#', '#', ' ', ' ', '$',' ', ' ','#', ' ','#', 
		'#', '#', '#', '#', '#', '#', '#', ' ', ' ', ' ',' ', ' ',' ', ' ','#', 
		'#', 'o', 'o', '#', ' ', ' ', '#', '#', ' ', ' ',' ', '$','#', ' ','#', 
		'#', 'o', 'o', ' ', ' ', ' ', '#', '#', ' ', '$',' ', ' ',' ', ' ','#', 
		'#', ' ', ' ', '#', ' ', ' ', '#', '#', ' ', '#','#', '#','#', '#','#', 
		'#', ' ', ' ', '#', ' ', '#', ' ', ' ', ' ', ' ',' ', '#','#', '#','#', 
		'#', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '$', ' ',' ', '#','#', '#','#', 
		'#', ' ', ' ', '#', '#', '#', ' ', ' ', ' ', '#','#', '#','#', '#','#', 
		'#', '#', '#', '#', '#', '#', '#', '#', '#', '#','#', '#','#', '#','#', ]


def chooseMap():
	"""
	returns (the map, the width of the map, the start position of the player)
	"""
	global width
	print
	print
	print "Welcome to this Sokoban solver"
	print
	print "1:"
	printMap(map1,10)
	print
	print "2:"
	printMap(map2,10)
	print
	print "3:"
	printMap(map3,9)
	print
	print "4:"
	printMap(map4,15)
	print
	choice = ""
	while(choice != "1" and choice != "2" and choice != "3" and choice != "4"):
		print "Please enter the number of  the map which should be solved by the program"
		choice = raw_input()
		if choice == "1":
			width = 10
			return ( map1,width, 3+3*width)
		elif choice == "2":
			width = 10
			return (map2,width, 5+6*width)
		elif choice == "3":
			width = 9
			return (map3,width, 6+4*width)
		elif choice == "4":
			width = 15
			return (map4,width,7+10*width)
		else: 
			print "Error : The only possible choices are  1, 2, 3 or 4."		

def estimateCostLimit(map):
    """
    estimate start cost limit using manhattan distance
    the returned bvalue is the sum of the distances form the boxes to the nearest goals
    """
    posBox=[]
    posGoal=[]
    for pos,case in enumerate(map):
        if case == '$':
            posBox.append(pos)
        if case=='o':
            posGoal.append(pos)

    distTot = 0
    for box in posBox:
        min = 10000
        for goal in posGoal:
            dist = distanceManhattan(box,goal)
            if dist < min :
                min = dist
        distTot += min
    return distTot
    
def distanceManhattan(pos1,pos2):
    """
    return the mahattan distance between pos1 and pos2
    """
    deltax = math.fabs(pos1%width - pos2%width)
    deltay = math.fabs(math.floor(pos1/width)-math.floor(pos2/width))

    return deltax+deltay


def deadzone(map):
	"""
    mark all the dead zones of the map
    these are  places where pushing a box would result in blocking it (the corners and the hollows
    exemple of hollow:
    ###   ###
       ###
    """
	for i in range(len(map)):
		#first mark all the corners
		if map[i]!='#' and map[i] != 'o':
			if (map[i+width] == '#' and ( map[i+1] == '#' or map[i-1] == '#')):
				map[i] = 'X'
			if (map[i-width] == '#' and ( map[i+1] == '#' or map[i-1] == '#')):
				map[i] = 'X' 		
	
	for i in range(len(map)):
                #mark all the hollow (without goal in it)
                #they are founded by looking for all the cornes if they form a hollow with another corner
		if map[i]=='X':
			#go up and left
			if (map[i+width] == '#' and  map[i+1] == '#' ):
				j= i-width
				while map[j] != 'X':
					if map[j+1] != '#' or map[j] == '#' or map[j] == 'o':
						break
					j-=width
					
				if map[j] == 'X':
					while map[j+width] !='X':
						map[j+width] = 'X'
						j+=width
				j= i-1			
				while map[j] != 'X':
					if map[j+width] != '#' or map[j] == '#' or map[j] == 'o':
						break
						j-=1
						
				if map[j] == 'X':
					while map[j+1] !='X':
						map[j+1] = 'X'
						j+=1
						
			#go up and right
			if (map[i+width] == '#' and  map[i-1] == '#' ):
				j= i-width
				while map[j] != 'X':
					if map[j-1] != '#' or map[j] == '#' or map[j] == 'o':
						break
					j-=width
					
				if map[j] == 'X':
					while map[j+width] !='X':
						map[j+width] = 'X'
						j+=width
				j= i+1
				while map[j] != 'X':
					if map[j+width] != '#' or map[j] == '#' or map[j] == 'o':
						break
					j+=1
					
				if map[j] == 'X':
					while map[j-1] !='X':
						map[j-1] = 'X'
						j-=1
			#go down and left
			if (map[i-width] == '#' and  map[i+1] == '#' ):
				j= i+width
				while map[j] != 'X':
					if map[j+1] != '#' or map[j] == '#' or map[j] == 'o':
						break
					j+=width
					
				if map[j] == 'X':
					while map[j-width] !='X':
						map[j-width] = 'X'
						j-=width
				j= i-1
				while map[j] != 'X':
					if map[j-width] != '#' or map[j] == '#' or map[j] == 'o':
						break
					j-=1
					
				if map[j] == 'X':
					while map[j+1] !='X':
						map[j+1] = 'X'
						j+=1
			#go down and right
			if (map[i-width] == '#' and  map[i-1] == '#' ):
				j= i+width
				while map[j] != 'X':
					if map[j-1] != '#' or map[j] == '#' or map[j] == 'o':
						break
					j+=width
					
					if map[j] == 'X':
						while map[j-width] !='X':
							map[j-width] = 'X'
							j-=width
				j= i+1
				while map[j] != 'X':
					if map[j-width] != '#' or map[j] == '#' or map[j] == 'o':
						break
					j+=1
                                        
				if map[j] == 'X':
					while map[j-1] !='X':
						map[j-1] = 'X'
						j-=1

	


