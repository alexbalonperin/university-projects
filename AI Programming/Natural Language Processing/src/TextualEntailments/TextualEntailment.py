'''
Created on Nov 14, 2011

@author: alex
'''
import re
class TextualEntailment:
    
    def __init__(self, hypothesis, text, pair_nb): 
        self.hypothesis = self.formatText(hypothesis)
        self.text = self.formatText(text)
        #=======================================================================
        # self.hypothesis = hypothesis.split()
        # self.text = text.split()
        #=======================================================================
        self.pair_nb = pair_nb
    
    def formatText(self,text):
        text = text.replace("'"," '")
        text = text.replace(":"," : ")
        text = text.replace(";"," ; ")
        text = text.replace(","," , ")
        text = text.replace(". "," . ")
        text = re.sub(".$"," . ",text)
        text = text.split()
        return text
        