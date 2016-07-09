'''
Created on Nov 23, 2011

@author: alex
'''
from ParserML import ParserML
from General.PATH import PATH

class ParserMLAdvanced(ParserML):
    
    def __init__(self, idf = None, test=False):
        ParserML.__init__(self, idf, test)
        self.pathToFeature = PATH+"file/Machine_Learning/featuresAdvanced.txt"
    
    def extractFeatures(self, feature_extractor, textualEntailment):
        return feature_extractor.getFeaturesAdvanced(textualEntailment)