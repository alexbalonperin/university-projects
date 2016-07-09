import os
from heuristic import*
import time

speed = 0.2
def printMap(map,width):
	"""
	print the map
	"""
	print
	i=0
	while i<len(map):
		print map[i],	# , to don t go to the next line 
		if i%width==width-1:
			print
		i = i+1
	                 



def printSolution(map,solution,width):
	"""
	print the solution path
	"""
	
	os.system("clear")
	print "solving the sokoban"
	print
	case = map[solution[0]]
	map[solution[0]] = 'P'
	printMap(map,width)
	map[solution[0]] = case
	
	time.sleep(speed)
	i=1
	while i < len(solution):
		printPath(map,solution[i-1],solution[i],width)
			
		os.system("clear")
		print "solving the sokoban"
		print
		case = map[solution[i]]
		map[solution[i]] = 'P'
		printMap(map,width)
		map[solution[i]] = case
		time.sleep(speed)
		
		(n,map) = moveBox(map, solution[i+1], solution[i],width)
		os.system("clear")
		print "solving the sokoban"
		print
		case = map[solution[i+1]]
		map[solution[i+1]] = 'P'
		printMap(map,width)
		map[solution[i+1]] = case
		time.sleep(speed)
		i+=2


def printPath(map,pos1,pos2,width):
	"""
	print the path between 2 points
	"""
	if pos1 != pos2:
		path = findPath(map,pos1,pos2,width)
		for pos in path:
			os.system("clear")
			print "solving the sokoban" 
			print
			case = map[pos]
			map[pos] = 'P'
			printMap(map,width)
			map[pos] = case
			time.sleep(speed)

def findPath(map,pos1,pos2,width):
        """
        return the path between 2 points
        """
        path=[]
        workingMap =list(map)
        queue =[]
        queue.append(pos1)
        workingMap[pos1]=1
        while queue != []:
                pos = queue.pop(0)
                for succ in [pos + width , pos-width , pos+1 , pos-1]:
                        if workingMap[succ]==' ' or workingMap[succ]=='o' or workingMap[succ]=='X':
                                queue.append(succ)
                                workingMap[succ] = workingMap[pos]+1
                        if succ == pos2:
                                break
        pos = pos2

        while pos != pos1:
                min = workingMap[pos]
                bestSucc =0
                for succ in [pos + width , pos-width , pos+1 , pos-1]:
                        if workingMap[succ]!=' ' and workingMap[succ]!='o' and workingMap[succ]!='#' and workingMap[succ]!='$' and workingMap[succ]!='&'and workingMap[succ]!='X':
                                if workingMap[succ] < min:
                                        min = workingMap[succ]
                                        bestSucc = succ
                path.append(bestSucc)
                pos = bestSucc
                
        path.remove(pos1)#because pos1 we only want the path without startand end position
        path.reverse()#because the path is reversed
        return path
        
        
                
