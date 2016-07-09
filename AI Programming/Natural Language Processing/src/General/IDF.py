'''
Created on Nov 22, 2011

@author: alex
'''
import re
class IDF:
    
    def __init__(self):
        pass
    
    def calculateIDF(self, textualEntailments):
        self.IDFs = self.initializeIDF(textualEntailments)
        self.IDFs = self.evaluateWeights(textualEntailments)
        print self.IDFs

    def evaluateWeights(self, textualEntailments):
        for word in self.IDFs.keys():
            counter = 0.0
            for textualEntailment in textualEntailments:
                if word in textualEntailment.hypothesis or word in textualEntailment.text:
                    counter = counter + 1
            self.IDFs[word] = 1.0/counter
        return self.IDFs

    def initializeIDF(self, textualEntailments):
        IDFs = dict()
        for textualEntailment in textualEntailments: 
            for word in textualEntailment.hypothesis+textualEntailment.text:
                if word not in IDFs.keys(): 
                    IDFs[word] = 0
        return IDFs
    
    def getIDF(self, word):
        if word in self.IDFs.keys():
            return self.IDFs[word]
        else: return 1

    def idf_costs(self, node1, node2):
        """
        Defines unit cost for edit operation on pair of nodes,
        i.e. cost of insertion, deletion, substitution are all 1
        """
        # insertion cost
        if node1 is None:
            m = re.search("^E\d+$", node2.label)
            if node2.label != '' and m is None:
                return self.getIDF(node2.label)
            else:return 0
        
        # deletion cost
        if node2 is None:
            return 0
        
        # substitution cost
        if node1.label != node2.label:
            return 1
        else:
            return 0
