'''
Created on Nov 21, 2011

@author: alex
'''
from LexicalMatching.WordMatching import WordMatching
from LexicalMatching.LemmaMatching import LemmaMatching
from LexicalMatching.LemmaPosMatching import LemmaPosMatching
from TextualEntailments.TextualEntailmentPre import TextualEntailmentPre
from TextualEntailments.TextualEntailmentTree import TextualEntailmentTree
from MachineLearning.AdvancedFeatures.Polarity import Polarity
from MachineLearning.AdvancedFeatures.TextNormalization import TextNormalization
from LexicalMatching.BLEU import BLEU

class Extractor:
    
    def __init__(self, idf = None):
        self.idf = idf
        self.decimal = 6
        if self.idf is not None:    
            self.wordMatcher = WordMatching("",True, self.idf) 
        else:
            self.wordMatcher = WordMatching()
            
        self.BLEUMatcher = BLEU() 
        self.lemmaPosMatcher = LemmaPosMatching()
        self.lemmaMatcher = LemmaMatching()
    
    def getFeatures(self, entailment):
        self.pair_nb = entailment.pair_nb
        self.distanceTree = self.getDistTree(entailment)
        self.BLEUScore = self.getBLEUScore(entailment)
        self.distanceLemmaPos = self.getDistLemmaPos(entailment)
        self.distanceLemma = self.getDistLemma(entailment)
        self.distanceWord = self.getDistWord(entailment)
        #print [self.distanceTree, self.BLEUScore, self.distanceLemmaPos, self.distanceLemma, self.distanceWord]
        return {'distTree':self.distanceTree, 'BLEU':self.BLEUScore, 'LemmaPos':self.distanceLemmaPos, 'Lemma':self.distanceLemma, 'Word':self.distanceWord}
    
    def getFeaturesAdvanced(self, entailment):
        #self.textNormalizer = TextNormalization()
        #entailment.hypothesis = self.textNormalizer.formatText(entailment.hypothesis)
        #entailment.text = self.textNormalizer.formatText(entailment.text)
        self.pol = Polarity()
        pol_H = self.pol.hasNegative(entailment.hypothesis)
        pol_T = self.pol.hasNegative(entailment.text)
        self.polarity = not (pol_H%2 == 0 and pol_T%2 == 0) or (pol_H%2 != 0 and pol_T%2 != 0)
        self.pair_nb = entailment.pair_nb
        self.distanceTree = self.getDistTree(entailment)
        self.BLEUScore = self.getBLEUScore(entailment)
        self.distanceLemmaPos = self.getDistLemmaPos(entailment)
        self.distanceLemma = self.getDistLemma(entailment)
        self.distanceWord = self.getDistWord(entailment)
        #print [self.BLEUScore, self.distanceLemmaPos, self.distanceLemma, self.distanceWord, self.polarity]
        #print [self.distanceTree, self.BLEUScore, self.distanceLemmaPos, self.distanceLemma, self.distanceWord, self.polarity]
        #return {'distTree':self.distanceTree, 'BLEU':self.BLEUScore, 'LemmaPos':self.distanceLemmaPos, 'Lemma':self.distanceLemma, 'Word':self.distanceWord, "Polarity":self.polarity}
        return {'BLEU':self.BLEUScore, 'LemmaPos':self.distanceLemmaPos, 'Lemma':self.distanceLemma, 'Word':self.distanceWord, "Polarity":self.polarity}

    
    def getBLEUScore(self, entailment):
        words_H = [ node.getWord() for sentence in entailment.hypothesis for node in sentence if node.getWord() != '']
        words_T = [node.getWord() for sentence in entailment.text for node in sentence if node.getWord() != '']
        return self.BLEUMatcher.entailScoreForOneTE(TextualEntailmentPre(words_H, words_T, self.pair_nb)) 
    
    def getDistTree(self, entailment):
        textEntail = TextualEntailmentTree(entailment.hypothesis, entailment.text, self.pair_nb)
        return textEntail.normalized_dist
    
    def getDistWord(self, entailment):
        words_H = [ node.getWord() for sentence in entailment.hypothesis for node in sentence if node.getWord() != '']
        words_T = [node.getWord() for sentence in entailment.text for node in sentence if node.getWord() != '']
        return self.wordMatcher.entailScoreForOneTE(TextualEntailmentPre(words_H, words_T, self.pair_nb)) 

    def getDistLemmaPos(self, entailment):
        words_H = [[node.getLemma(), node.getPos()] for sentence in entailment.hypothesis for node in sentence]
        words_T = [[node.getLemma(), node.getPos()] for sentence in entailment.text for node in sentence] 
        return self.lemmaPosMatcher.entailScoreForOneTE(TextualEntailmentPre(words_H, words_T, self.pair_nb)) 
    
    def getDistLemma(self, entailment):
        words_H = [node.getLemma() for sentence in entailment.hypothesis for node in sentence]
        words_T = [node.getLemma() for sentence in entailment.text for node in sentence] 
        return self.lemmaMatcher.entailScoreForOneTE(TextualEntailmentPre(words_H, words_T, self.pair_nb)) 
    
    