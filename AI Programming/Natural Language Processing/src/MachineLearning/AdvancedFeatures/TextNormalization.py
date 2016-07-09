'''
Created on Nov 23, 2011

@author: alex
'''
import re

class TextNormalization:
    
    def __init__(self):
        self.ponctuation = ["'",":",";",",","."]
    
    def formatText(self, text):
        for sentence in text:
            print sentence
            for node in sentence:
                if node.getLemma() in self.ponctuation:
                    sentence.remove(node)
                else:
                    node.setLemma(self.formatLemma(node.getLemma()))
            print sentence
            raw_input("pause")
        #for word in text:
        #    text = self.ponctuationRemoval(word)
    
    def formatLemma(self, lemma):
        pass
        
    
    def date_template(self, day, month, year): 
        if year is not None and day is not None:
            return day+"."+month+"."+year 
        else:
            if day is not None:
                return day+"."+month
            else:
                return month+"."+year
    def currency_template(self, number, currency):
        return currency+number
     
    def time_template(self,seconds, minutes, hours): 
        if seconds is not None:
            return hours+":"+minutes+":"+seconds
        else:
            return hours+":"+minutes
        
        
        