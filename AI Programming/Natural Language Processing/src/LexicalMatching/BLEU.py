'''
Created on Nov 17, 2011

@author: alex
'''
from LexicalMatching import LexicalMatching
from General.PATH import PATH
import math

class BLEU(LexicalMatching):
    
    def __init__(self,textualEntailments = ""):
        LexicalMatching.__init__(self,textualEntailments)
        self.folder = PATH+"file/bleu"
        
    def getEntailScores(self,threshold,path):
        self.fileWriter.writeFile(path, "ranked: no\n","w")
        for textEntail in self.textualEntailments:
            Modified_BLEU = self.entailScoreForOneTE(textEntail)
            self.writeEntailDecision(threshold, textEntail.pair_nb, path, Modified_BLEU)
    
    def entailScoreForOneTE(self,textEntail):
        text = [word.lower() for word in textEntail.text]
        hypothesis = [word.lower() for word in textEntail.hypothesis]
        prec_n = []
        prec_n.append(self.gramsPrec(text, hypothesis))
        for n in range(2,5):
            prec_n.append(self.gramsPrec(self.getGrams(text, n), self.getGrams(hypothesis, n)))
        return math.fsum(prec_n)/len(prec_n)
    
    def gramsPrec(self, gramsT, gramsH):
        counter = 0.0
        for h_gram in gramsH:
            for t_gram in gramsT:
                if self.match(h_gram, t_gram):
                    counter = counter + 1
                    break
        try:
            prec = counter/len(gramsH)
        except ZeroDivisionError:
            prec = 0
        return prec
        
    def getGrams(self, text,n):
        grams = []
        tmp = []
        i = 1
        for word in text:
            tmp.append(word)
            if i >= n:
                grams.append(" ".join(tmp))
                tmp.pop(0)
            i = i + 1
        return grams