'''
Created on Nov 17, 2011

@author: alex
'''
from Parsing.Parser import Parser
from TextualEntailments.TextualEntailment import TextualEntailment
from General.PATH import PATH

class ParserNormal(Parser):
    
    def __init__(self):
        Parser.__init__(self)
        self.path = PATH+"file/RTE2_dev.xml"
        
    def getContent(self,entailment):
        start = False
        text = ""
        for letter in entailment:
            if letter == '<':
                start = False
            if start:
                text = text + letter
            if letter == ">":
                start = True
        return text 
    
    def addEntailment(self,hypothesis,text, counter):
        self.textualEntailments.append(TextualEntailment(hypothesis,text, counter))
    
    def getText(self,f):
        return self.getContent(f.readline())
    
    def getHypothesis(self,f):
        return self.getContent(f.readline())