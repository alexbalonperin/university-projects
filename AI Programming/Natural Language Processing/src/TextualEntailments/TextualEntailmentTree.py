'''
Created on Nov 19, 2011

@author: alex
'''

from General.Node import Node
from SyntacticMatching.tree_edit_dist import TreeEditDist
import re,sys

class TextualEntailmentTree:
    
    def __init__(self, hypothesis, text, pair_nb, has_idf = False): 
        self.pair_nb = pair_nb
        self.hypothesis = self.createTrees(hypothesis)
        self.text = self.createTrees(text)
        if not has_idf:
            self.treeEditDist = TreeEditDist()
            self.distance = self.treeEditDist.distance(self.hypothesis, self.text)
            self.normalized_dist = self.distance/self.hypothesisLength(hypothesis)
        self.hypothesisLength = self.hypothesisLength(hypothesis)
    
    def setDistance(self, distance):
        self.distance = distance
        self.normalized_dist = self.distance/self.hypothesisLength
        
    def hypothesisLength(self, hypothesis):
        length = 0.0
        for sentence in hypothesis:
            length = length + len(sentence)
        return length
    
    def createTrees(self, sentences):
        trees = []
        highest = 0
        for sentence in sentences:
            for node in sentence:
                highest = self.getHighest(node, highest) 
                if node.getPID() == -1:    
                    try:
                        trees.append(self.createSingleTree(sentence,node)) 
                    except RuntimeError:
                        print "RuntimeError...."
                        sys.exit(0) 
        if len(trees) > 1:
            return self.joinTrees(trees, int(highest)+1)
        else: return trees[0]
    
    def getHighest(self, node, highest):
        m = re.search("E\d+",node.getID())
        if m:
            counter = re.sub("\D","",m.group(0))
            if counter > highest:
                return counter
        return highest  
        
    def joinTrees(self, trees, highest):
        joinTree = ["E"+str(highest)]
        for tree in trees:
            joinTree.append(tree)
        return Node(*joinTree)
        
    def createSingleTree(self, nodes,root):
        tree = [root.getLemma()]
        for node in nodes:
            if node.getPID() == root.getID():
                tree.append(self.createSingleTree(nodes,node))
        return Node(*tree)
