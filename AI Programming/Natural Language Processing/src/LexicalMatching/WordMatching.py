'''
Created on Nov 14, 2011

@author: alex
'''
from LexicalMatching import LexicalMatching
from General.PATH import PATH

class WordMatching(LexicalMatching):

    def __init__(self,textualEntailments = "", has_idf = False, idf = None):
        LexicalMatching.__init__(self,textualEntailments, has_idf, idf)
        if idf:
            self.folder = PATH+"file/wordmatching_idf"
        else:
            self.folder = PATH+"file/wordmatching"