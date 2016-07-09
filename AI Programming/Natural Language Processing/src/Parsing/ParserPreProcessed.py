'''
Created on Nov 17, 2011

@author: alex
'''
from Parsing.Parser import Parser
from TextualEntailments.TextualEntailmentPre import TextualEntailmentPre
from General.PATH import PATH

class ParserPreProcessed(Parser):
    
    def __init__(self):
        Parser.__init__(self)
        self.path = PATH+"file/RTE2_dev.preprocessed.xml"

    def addEntailment(self,hypothesis,text, counter):
        self.textualEntailments.append(TextualEntailmentPre(hypothesis,text, counter))

    def getContent(self,f,end_tag,catch_tag):
        line = f.readline()
        lemmas = []
        while line != end_tag:
            line = f.readline()
            if line.strip() == catch_tag:
                line = f.readline()
                lemmas.append(line.strip())
        return lemmas
    
    def getText(self,f):
        return self.getContent(f,"</text>\n","<lemma>")
    
    def getHypothesis(self,f):
        return self.getContent(f,"</hypothesis>\n","<lemma>")
    
    