'''
Created on Nov 21, 2011

@author: alex
'''

from Parsing.Parser import Parser
from TextualEntailments.TextualEntailmentPre import TextualEntailmentPre
from General.PATH import PATH
from General.NodeParser import NodeParser
from MachineLearning.FeatureExtraction.Extractor import Extractor
from Tools.FileHandler import FileHandler
import re,sys

class ParserML(Parser):
    
    def __init__(self, idf = None, test = False):
        Parser.__init__(self)
        if test:
            self.path = PATH+"file/preprocessed-blind-test-data.xml"
        else:
            self.path = PATH+"file/RTE2_dev.preprocessed.xml"
        self.fileWriter = FileHandler()
        self.pathToFeature = PATH+"file/Machine_Learning/features.txt"
        self.idf = idf
    
    def parseFile(self):
        print "Starting the parsing..."
        feature_extractor = Extractor(self.idf)
        f = open(self.path, 'r')
        self.removeHeader(f)
        featuresets = []
        while 1:
            line = f.readline()
            if not line or line == "</entailment-corpus>\n":
                break
            pair_nb = self.getPairNb(line)
            entailment_decision = self.getEntailmentDecision(line)
            text = self.getText(f)
            hypothesis = self.getHypothesis(f)
            textualEntailment = self.addEntailment(hypothesis, text, pair_nb)
            features = (self.extractFeatures(feature_extractor, textualEntailment), entailment_decision)
            featuresets.append([pair_nb,features])
            f.readline()
        f.close()
        self.writeFeatures(featuresets)
        print "Parsing finished..."
        self.textualEntailments.sort(key = lambda textualEntailment: textualEntailment.pair_nb)
        return [self.textualEntailments, featuresets] 
    
    def extractFeatures(self, feature_extractor, textualEntailment):
        return feature_extractor.getFeatures(textualEntailment)
    
    def writeFeatures(self, toWrites):
        self.fileWriter.writeFile(self.pathToFeature,"ID    Dist Tree     BLEU Score    Lemma-Pos     Dist Lemma    Dist Word \n", "w")
        self.fileWriter.writeFile(self.pathToFeature,"--    ----------    ----------    ----------    ----------    ----------\n", "a")
        toWrites = sorted(toWrites, key=lambda toWrite: int(toWrite[0]))
        for toWrite in toWrites:
            self.fileWriter.writeFile(self.pathToFeature,toWrite[0]+":    "+str("    ".join(["%.8f" %score for score in toWrite[1][0].values()]))+"\n", "a")
    
    def getEntailmentDecision(self, line):
        try:
            m =  (re.search("YES|NO" ,line)).group(0)
        except AttributeError:
            m = ""
        return m        

        
    def addEntailment(self,hypothesis,text, counter):
        textualEntailment = TextualEntailmentPre(hypothesis,text, counter)
        self.textualEntailments.append(textualEntailment)
        return textualEntailment

    def getContent(self,f,end_tag):
        line = f.readline()
        catch_tags = ["<sentence","<node id","<word>","<lemma>","<pos-tag>", "<relation parent"]
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
                                node.setWord(line.strip())
                            if catch_tags[3] in line.strip():
                                line = f.readline()
                                node.setLemma(line.strip())
                            if catch_tags[4] in line.strip():
                                line = f.readline()
                                node.setPos(line.strip())
                            if catch_tags[5] in line.strip():
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
    