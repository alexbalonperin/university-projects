'''
Created on Nov 23, 2011

@author: alex
'''
class Polarity:
    
    def __init__(self):
        self.negatives = ["not", "refuse","wrong","deny","no","false","ignore","cannot","never","unsuccessfully"]
    
    def hasNegative(self, text):
        counter = 0
        for sentence in text:
            for node in sentence:
                if node.getLemma() in self.negatives:
                    counter = counter + 1
        return counter   
    
    