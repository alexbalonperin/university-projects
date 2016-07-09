'''
Created on Nov 21, 2011

@author: alex
'''
class NodeParser:
    
    def __init__(self):
        self.id = -1
        self.pid = -1
        self.lemma = ""
        self.visited = False
        self.word = ""
        self.pos = ""
    
    def __ne__(self, other):
        return self.id != other.id or self.pid != other.pid or self.lemma != other.lemma
    
    def __repr__(self):
        """
        string representation of tree as a labeled bracket structure
        """
        return "[Lemma = " + str(self.lemma) + ", ID = " + str(self.id) + ", PID = " + str(self.pid) +", Word = " + str(self.word) +", POS = " + str(self.pos) +"]"  
    
    def setWord(self, word):
        self.word = word
        
    def getWord(self):
        return self.word
    
    def setPos(self,pos):
        self.pos = pos
        
    def getPos(self):
        return self.pos
    
    def setVisited(self, visited):
        self.visited = visited
        
    def getVisited(self):
        return self.visited
        
    def setID(self, new_id):
        self.id = new_id
    
    def getID(self):
        return self.id 
        
    def setPID(self, new_pid):
        self.pid = new_pid
    
    def getPID(self):
        return self.pid
    
    def setLemma(self, lemma):
        self.lemma = lemma
    
    def getLemma(self):
        return self.lemma