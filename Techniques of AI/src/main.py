#-*- coding: utf-8 -*-
'''
Created on 17 avr. 2011

@author: geolebargeo
'''
from IDA_star import * 
import printing
from initIDA_star import *
from copy import *
from heuristic import *

def main():
	map = []
	mapCopy = []
	(map,width,startPos) = chooseMap()    
	case = map[startPos]
	map[startPos] = 'P'
	printing.printMap(map,width)
	map[startPos] = case
	mapCopy = deepcopy(map)
	accesArea = accessibleArea(map,startPos,width)#build the access area map
	printing.printMap(accesArea,width)
	(solution, new_cost_limit) = IDA_star(map,startPos,width)
	if solution != None:
		print "solution"
		printing.printSolution(mapCopy, solution,width)



if __name__ == '__main__':
    main()





