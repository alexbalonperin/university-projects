# -*-coding:utf-8 -*  
import initIDA_star
from heuristic import *
import time
import printing
import random


Infinity = badMove #upper limit for the cost limit
expectedQuality = initIDA_star.expectedQuality
moveCost = 1 #cost for one move
accesAreaList=[] #list of previous access area
costOfAccesAreaList=[]

def IDA_star(map,startPos,width):
        """
        return if founded the solution givend by IAD_star  algorithm
        """
        costLimit = initIDA_star.estimateCostLimit(map)#estimate start cost limit using manhattan distance
        initIDA_star.deadzone(map)
        printing.printMap(map,width)
 
        while True:
                del(accesAreaList[:])#reset the list
                del(costOfAccesAreaList[:])#reset the list
                
                print "cost limit",costLimit
                (solution, costLimit) = DFS(0, startPos, costLimit, [startPos], map, 0,width)#launch the recusive search
                if solution != None:
                    return (solution, costLimit)
                if costLimit >= Infinity:
                    return (None,costLimit)
 

def DFS(startCost, pos, costLimit, pathSoFar, map, boxPlaced,width):
        """
        returns (solution-sequence or None, new cost limit)
        """
 
        minimumCost = startCost + heuristic(pos, map, boxPlaced) #evaluate the cost function to compare it the the cost limit

        if minimumCost > costLimit: #if cost to hight kill the branch
            return (None, minimumCost)
        if problemSolved(map): #if solution founded return it
            printing.printMap(map,width)
            return (pathSoFar, costLimit)
 
        nextCostLimit = Infinity
	
        accesArea = accessibleArea(map,pos,width)#build the access area map

        #check if the configuration was obtained earlier and if yes, depending on expectedQuality
        #check if the new path to reach the configuration is better than the previous one. if not kill the branch
        for i,accMap in enumerate(accesAreaList):
                if accMap == accesArea:
                    if costOfAccesAreaList[i] < minimumCost or random.randint(1,100) > expectedQuality :
                        return(None, badMove)#bad move return bad move as cost value to avoid problems with the cost limit update
                        #because since the search stoped before being stoped by the cost limit, the curent cost is lower thant the cost limit

                        #if the new configuration was better and was kept, remove the previous form the lists 
                        del(accesAreaList[i])
                        del(costOfAccesAreaList[i])
                
        accesAreaList.append(accesArea)#add the new configuration to the lists
        costOfAccesAreaList.append(minimumCost)
	
        
        for boxPos in boxReachable(accesArea, map,width):#for all reachable boxes
            for posToMove in successors(boxPos,width): #for all possible moves
                #posToMove is the position of the agent when it moves the box
                if accesArea[posToMove] != 1:
                    continue #if pos to move can not be reached try another position
                
                newStartCost = startCost + moveCost
                (asPlaceBox, newMap) = moveBox (map , boxPos , posToMove,width)#move the box
		        
                if newMap == None:#if the move is not allowed
                    continue # try another one
                        
                        #call the function with the new configuration 
                (solution, newCostLimit) = DFS(newStartCost, boxPos, costLimit, pathSoFar + [posToMove,boxPos], newMap, boxPlaced+asPlaceBox,width)
                if solution != None:#if a sulution is founded, stop the search
                    return (solution, newCostLimit)
                nextCostLimit = min(nextCostLimit, newCostLimit)

        return (None, nextCostLimit)#if no solution founded return the minimum cost returned
 



def successors(pos,width):
    """
    return the position around the given ones
    """
    return [pos + width , pos-width, pos+1 , pos-1]

