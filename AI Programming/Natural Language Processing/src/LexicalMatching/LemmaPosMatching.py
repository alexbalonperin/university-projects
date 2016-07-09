'''
Created on Nov 14, 2011

@author: alex
'''
from LexicalMatching import LexicalMatching
from General.PATH import PATH

class LemmaPosMatching(LexicalMatching):

    def __init__(self,textualEntailments=""):
        LexicalMatching.__init__(self,textualEntailments)
        self.folder = PATH+"file/lemmaposmatching"