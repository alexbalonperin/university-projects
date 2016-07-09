'''
Created on Nov 14, 2011

@author: alex
'''
from Error.ParsingError import ParsingError
import re

class Parser:
    
    def __init__(self):
        self.textualEntailments = []
    
    def parseFile(self):
        print "Starting the parsing..."
        f = open(self.path, 'r')
        self.removeHeader(f)
        while 1:
            line = f.readline()
            if not line or line == "</entailment-corpus>\n":
                break
            pair_nb = self.getPairNb(line)
            text = self.getText(f)
            hypothesis = self.getHypothesis(f)
            self.addEntailment(hypothesis, text, pair_nb)
            f.readline()
        f.close()
        print "Parsing finished..."
        self.textualEntailments.sort(key = lambda textualEntailment: textualEntailment.pair_nb)
        return self.textualEntailments
    
    def getPairNb(self, line):
        if "<pair id" in line.strip():
            m = re.search("\d+",line.strip())
            return m.group(0)
        else:
            raise ParsingError("The xml file is not standard")
    
    def addEntailment(self,hypothesis,text, counter):
        raise NotImplementedError("Subclass must implement abstract method")
    
    def getText(self,entailment):
        raise NotImplementedError("Subclass must implement abstract method")
        
    def getHypothesis(self,entailment):
        raise NotImplementedError("Subclass must implement abstract method")
    
    def getFileSize(self):
        f = open(self.path, 'r')
        data = f.read()
        f.close()
        return len(data)            

    def getEntailment(self,f):
        line = f.readline()
        entailment = ""
        while line != "</pair>\n":
            entailment = entailment + line
            line = f.readline()
        return entailment.split(" ")

    def removeHeader(self,f):
        line = f.readline()
        while line != "<entailment-corpus>\n":
            line = f.readline()