 # -*-coding:utf-8 -* 
import isBlocked

badMove = 10000

def heuristic(pos, map, boxPlaced):
	"""
	heuristic for the cost function
	"""
	if map[pos] == '#': 
		#if in a wall
		return badMove
	if map[pos] == '&': 
		#if in an already placed box
		return badMove
    
    
    #to encorage moving boxes
	return -4*boxPlaced
        
    


def accessibleArea(map,pos,width):
        """
        return a map containing '1' where the agent can go
        """
        acces = list(map)
        accArea(acces,pos,width)#launch the recursive function on the curent position of the agent
        
        return acces
        

def accArea(area, pos,width):
        """
        recursive function placing '1' where the agent can go
        """
        area[pos] = 1#mark the position
        for case in [pos + width , pos-width , pos+1 , pos-1]:#launch the function on every successor of the position
                #which is accessible and not yet visited
                if area[case]!= '#' and area[case]!= '$' and area[case]!= '&' and area[case] != 1:
                        accArea(area , case,width)

def boxReachable(accesArea, map,width):
        """
        return all the boxes (placed or not) that could be reached by the agent
        """
        boxes = []
        for i,pos in enumerate(map):
                if pos=='$' or pos=='&':
                        for around in [i + width , i-width , i+1 , i-1]:#add to the list the boxes that have
                                #at least one position around which is accessible for the agent
                                if accesArea[around] == 1:
                                        boxes.append(i)
                                        break
        return boxes




def moveBox(map, newPos, oldPos,width):
    """
    move a box according the the move made by the agent and return the resulting map and if the box as been placed
    if the move is bad return None for the new map
    """
    
    newMap = list(map)
    move = newPos - oldPos #calculate the move made by the agent
    
    if map[newPos] == '$':#if thez moved box has not yet be placed
        newMap[newPos] = ' '
        if newMap[newPos+move] == 'o':#if the new position of the box is a goal
            newMap[newPos+move] = '&' 
            return (1,newMap) 
        
        if newMap[newPos+move] == '#':#if the new position of the box is a wall
            return (0,None)
        if newMap[newPos+move] == '&':#if the new position of the box is a placed box
            return (0,None)
        if newMap[newPos+move] == '$':##if the new position of the box is a box
            return (0,None)
        if newMap[newPos+move] == 'X':##if the new position of the box is a dead zone
            return (0,None)

        if isBlocked.isBlocked(newMap, newPos+move,width): #if the move would block the box 
            return(0,None)
        
        newMap[newPos+move] = '$'#if all test have been passed the box is just moved
        return (0,newMap)

    else: #if the moved box was already placed
        newMap[newPos] = 'o'
        
        if newMap[newPos+move] == 'o':#if the new pos is also a goal
            newMap[newPos+move] = '&' 
            return (0,newMap)#0 for the number of placed boxes since the box was already placed 
        
        if newMap[newPos+move] == '#':#if the new position of the box is a wall
            return (0,None)
        if newMap[newPos+move] == '&':#if the new position of the box is a placed box
            return (0,None)
        if newMap[newPos+move] == '$':###if the new position of the box is a box
            return (0,None)
        if newMap[newPos+move] == 'X':#if the new position of the box is a dead zone
            return (0,None)
        
        newMap[newPos+move] = '$' #if the box is no more placed
        return (-1,newMap) #-1 since there a lower number of placed boxes
        
    
def problemSolved(map):
    """
    determin if a solutiuon as been reached (no more box to place
    """
    solved = True
    for case in map: #true if there is no more boxes to place
        if case == '$':
            solved = False
    
    return solved
        
