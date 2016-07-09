'''
Created on Nov 17, 2011

@author: alex
'''

from Parsing.Parser import Parser
from TextualEntailments.TextualEntailmentPre import TextualEntailmentPre
from General.PATH import PATH

class ParserPreProcessedPos(Parser):
    
    def __init__(self):
        Parser.__init__(self)
        self.path = PATH+"file/RTE2_dev.preprocessed.xml"

    def addEntailment(self,hypothesis,text, counter):
        self.textualEntailments.append(TextualEntailmentPre(hypothesis,text, counter))

    def getContent(self,f,end_tag,catch_tag1,catch_tag2):
        line = f.readline()
        lemmas = []
        pos = []
        while line != end_tag:
            line = f.readline()
            if line.strip() == catch_tag1:
                line = f.readline()
                lemmas.append(line.strip())
            if line.strip() == catch_tag2:
                line = f.readline()
                pos.append(line.strip())
        return [lemmas, pos]
    
    def getText(self,f):
        return self.getContent(f,"</text>\n","<lemma>", "<pos-tag>")
    
    def getHypothesis(self,f):
        return self.getContent(f,"</hypothesis>\n","<lemma>","<pos-tag>")
    
    