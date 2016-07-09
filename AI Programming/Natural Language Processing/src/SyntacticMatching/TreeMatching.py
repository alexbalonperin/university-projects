'''
Created on Nov 20, 2011

@author: alex
'''
from LexicalMatching.LexicalMatching import LexicalMatching
from General.PATH import PATH

class TreeMatching(LexicalMatching):

    def __init__(self,textualEntailments):
        LexicalMatching.__init__(self,textualEntailments)
        self.folder = PATH+"file/treematching"
        
    def getEntailScores(self,threshold,path):
        self.fileWriter.writeFile(path, "ranked: no\n","w")
        for textEntail in self.textualEntailments:
            score = self.entailScoreForOneTE(textEntail)
            self.writeEntailDecision(threshold, textEntail.pair_nb, path, score)  
            
    def entailScoreForOneTE(self, textEntail):
        return textEntail.normalized_dist
    
    