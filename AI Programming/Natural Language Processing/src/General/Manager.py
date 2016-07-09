'''
Created on Nov 17, 2011

@author: alex
'''
from Parsing.ParserNormal import ParserNormal
from Parsing.ParserPreProcessed import ParserPreProcessed
from Parsing.ParserPreProcessedPos import ParserPreProcessedPos
from Parsing.ParserTree import ParserTree
from Parsing.ParserML import ParserML
from Parsing.ParserMLAdvanced import ParserMLAdvanced
from LexicalMatching.WordMatching import WordMatching
from LexicalMatching.LemmaMatching import LemmaMatching
from LexicalMatching.LemmaPosMatching import LemmaPosMatching
from LexicalMatching.BLEU import BLEU
from SyntacticMatching.TreeMatching import TreeMatching
from SyntacticMatching.tree_edit_dist import TreeEditDist
from Optimizer.SimpleOptimizer import SimpleOptimizer
from MachineLearning.Classification import Classification
from General.IDF import IDF
import sys

class Manager:
    
    def __init__(self):
        self.part = 1
        self.subpart = 1
    
    def choosePart(self):
        try:
            self.part = int(input("Choose a part of the project (1,2,3 or 4):"))   
        except Exception, e:
            print e
            sys.exit(0)
        if self.part == 1: 
            self.part1()
        elif self.part == 2:
            self.part2()
        elif self.part == 3:
            self.part3()
        elif self.part == 4:
            self.part4()
    
    def part4(self): 
        #preparser = ParserNormal() 
        #textualEntailments = preparser.parseFile()
        #idf = IDF()
        #idf.calculateIDF(textualEntailments) 
        parser = ParserMLAdvanced() 
        [textualEntailments_training, featuresets_training] = parser.parseFile()
        parser = ParserMLAdvanced(None, True) 
        [textualEntailments_test, featuresets_test] = parser.parseFile()
        classif = Classification()
        classif.classProcessNaiveBayesTest(featuresets_training, featuresets_test, True)
        #classif.classProcessDecisionTree(featuresets, True)
         
    def part3(self):
        try:
            self.subpart = int(input("Choose the subpart\n    1:Feature Extraction\n    2:Classification\n    3:Cross-Validation\n"))
        except Exception, e:
            print e
            sys.exit(0)
        if self.subpart == 1:   
            self.part3sub1()
        elif self.subpart == 2:
            self.part3sub2()
        elif self.subpart == 3:
            self.part3sub3()

    def part3sub3(self):
        parser = ParserML() 
        [textualEntailments, featuresets] = parser.parseFile()
        classif = Classification()
        classif.classProcessNaiveBayes(featuresets, True)

    def part3sub1(self):
        parser = ParserML() 
        parser.parseFile()
        print "check the feature.txt file"
   
    def part3sub2(self):
        parser = ParserML() 
        [textualEntailments, featuresets] = parser.parseFile()
        classif = Classification()
        classif.classProcessNaiveBayes(featuresets)
        
    def part2(self):
        try:
            self.subpart = int(input("Choose the subpart\n    1:Tree Edit Distance\n    2:Entailment judgement\n    3:IDF\n"))
        except Exception, e:
            print e
            sys.exit(0)
        if self.subpart == 1:   
            self.part2sub1()
        else:
            try:
                self.threshold = float(input("Give a threshold or -1 if you want to find the optimal threshold:"))
            except Exception, e:
                print e
                sys.exit(0)
            if self.subpart == 2:
                self.part2sub2()
            elif self.subpart == 3:
                self.part2sub3()
    
    def part2sub3(self):
        preparser = ParserPreProcessed()
        idf = IDF()
        idf.calculateIDF(preparser.parseFile())
        parser = ParserTree(True) 
        textualEntailments = parser.parseFile()
        self.treeEditDist = TreeEditDist()
        for textualEntailment in textualEntailments:
            textualEntailment.setDistance(self.treeEditDist.distance(textualEntailment.hypothesis, textualEntailment.text, idf.idf_costs))
            textualEntailment.distance
        treeMatcher = TreeMatching(textualEntailments)
        optimizer = SimpleOptimizer(textualEntailments, self.threshold, treeMatcher)
        optimizer.getOptThres()
    
    def part2sub2(self):
        parser = ParserTree() 
        textualEntailments = parser.parseFile()
        treeMatcher = TreeMatching(textualEntailments)
        optimizer = SimpleOptimizer(textualEntailments, self.threshold, treeMatcher)
        optimizer.getOptThres()
    
    def part2sub1(self):
        parser = ParserTree()  
        textualEntailments = sorted(parser.parseFile(), key=lambda textualEntailment: int(textualEntailment.pair_nb))
        for textualEntailment in textualEntailments:
            print "distance(pair = %d) = %d" % (int(textualEntailment.pair_nb), textualEntailment.distance)
            print "normalized distance(pair = %d) = %4f" % (int(textualEntailment.pair_nb), textualEntailment.normalized_dist)
            print
        
    def part1(self):
        try:
            self.subpart = int(input("Choose the subpart\n    1:Word matching\n    2:Lemma matching\n    3:Lemma + POS matching\n    4:BLEU\n    5:IDF\n"))
            self.threshold = float(input("Give a threshold or -1 if you want to find the optimal threshold:"))
        except Exception, e:
            print e
            sys.exit(0)
        if self.subpart == 1:   
            self.part1sub1()
        elif self.subpart == 2:
            self.part1sub2()
        elif self.subpart == 3:
            self.part1sub3()
        elif self.subpart == 4:
            self.part1sub4()
        elif self.subpart == 5:
            self.part1sub5()
        self.optimizer.getOptThres()
    
    def part1sub5(self):
        parser = ParserNormal() 
        textualEntailments = parser.parseFile()
        lexicalMatcher = WordMatching(textualEntailments,True) 
        self.optimizer = SimpleOptimizer(textualEntailments, self.threshold, lexicalMatcher) 
    
    def part1sub4(self):
        parser = ParserNormal() 
        textualEntailments = parser.parseFile()
        lexicalMatcher = BLEU(textualEntailments)
        self.optimizer = SimpleOptimizer(textualEntailments, self.threshold, lexicalMatcher) 
    
    def part1sub3(self):
        parser = ParserPreProcessedPos() 
        textualEntailments = parser.parseFile()
        lexicalMatcher = LemmaPosMatching(textualEntailments)
        self.optimizer = SimpleOptimizer(textualEntailments, self.threshold, lexicalMatcher) 
    
    def part1sub2(self):
        parser = ParserPreProcessed()
        textualEntailments = parser.parseFile()
        lexicalMatcher = LemmaMatching(textualEntailments) 
        self.optimizer = SimpleOptimizer(textualEntailments, self.threshold, lexicalMatcher) 
    
    def part1sub1(self):
        parser = ParserNormal() 
        textualEntailments = parser.parseFile()
        lexicalMatcher = WordMatching(textualEntailments) 
        self.optimizer = SimpleOptimizer(textualEntailments, self.threshold, lexicalMatcher) 