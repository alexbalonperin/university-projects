'''
Created on Nov 17, 2011

@author: alex
'''

from Parsing.Parser import Parser
from TextualEntailments.TextualEntailmentTree import TextualEntailmentTree
from General.PATH import PATH
from General.NodeParser import NodeParser
import re
  
class ParserTree(Parser):
    
    def __init__(self, idf = False):
        Parser.__init__(self)
        self.path = PATH+"file/RTE2_dev.preprocessed.xml"
        self.idf = idf

    def addEntailment(self,hypothesis,text, counter):
        if self.idf:
            self.textualEntailments.append(TextualEntailmentTree(hypothesis,text,counter, True))
        else:
            self.textualEntailments.append(TextualEntailmentTree(hypothesis,text,counter))

    def getContent(self,f,end_tag):
        line = f.readline()
        catch_tags = ["<sentence","<node id","<lemma>", "<relation parent"]
        end_tags = ["</sentence>", "</node>"]
        sentences = []
        while line != end_tag:
            line = f.readline()
            if catch_tags[0] in line.strip():
                nodes = []
                while line.strip() != end_tags[0]:
                    line = f.readline()
                    if catch_tags[1] in line.strip():
                        node = NodeParser()
                        m = re.search("\d+|E\d+",line.strip())
                        node.setID(m.group(0))
                        line = f.readline()
                        while line.strip() != end_tags[1]:
                            if catch_tags[2] in line.strip():
                                line = f.readline()
                                node.setLemma(line.strip())
                            if catch_tags[3] in line.strip():
                                m = re.search("\d+|E\d+",line.strip())
                                node.setPID(m.group(0))
                            line = f.readline()
                        nodes.append(node)   
                sentences.append(nodes)
        return sentences
    
    def getText(self,f):
        return self.getContent(f,"</text>\n")
    
    def getHypothesis(self,f):
        return self.getContent(f,"</hypothesis>\n")
    
    