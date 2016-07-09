'''
Created on Nov 21, 2011

@author: alex
'''
from Tools.FileHandler import FileHandler
from General.IDF import IDF

class LexicalMatching:
    
    def __init__(self, textualEntailments = "", has_idf = False, idf = None):
        self.textualEntailments = textualEntailments
        self.fileWriter = FileHandler()
        self.has_idf = has_idf
        if self.has_idf and idf is None:
            self.idf = IDF()
            self.idf.calculateIDF(textualEntailments)
        if idf is not None:
            self.idf = idf
            print self.idf.IDFs
    
    def match(self,w1,w2):
        return w1==w2
    
    def getEntailScores(self,threshold,path):
        i = 1
        self.fileWriter.writeFile(path, "ranked: no\n","w")
        for textEntail in self.textualEntailments:
            score = self.entailScoreForOneTE(textEntail)
            self.writeEntailDecision(threshold, textEntail.pair_nb, path, score)  
            i = i + 1
            
    def entailScoreForOneTE(self,textEntail):
        counter = 0.0
        for h_word in textEntail.hypothesis:
            for t_word in textEntail.text:
                if self.match(h_word, t_word):
                    if self.has_idf:
                        counter = counter + self.idf.getIDF(h_word)
                    else:
                        counter = counter + 1
                    break
        return counter/len(textEntail.hypothesis)  
        
    def writeEntailDecision(self, threshold, i,path, score):
        if score >= threshold:
            toWrite = str(i)+" "+"YES\n"
        else:
            toWrite = str(i)+" "+"NO\n"
        self.fileWriter.writeFile(path, toWrite,"a")
                        