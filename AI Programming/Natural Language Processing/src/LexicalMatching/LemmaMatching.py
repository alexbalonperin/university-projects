'''
Created on Nov 17, 2011

@author: alex
'''
from LexicalMatching import LexicalMatching
from General.PATH import PATH

class LemmaMatching(LexicalMatching):

    def __init__(self,textualEntailments=""):
        LexicalMatching.__init__(self,textualEntailments)
        self.folder = PATH+"file/lemmamatching"