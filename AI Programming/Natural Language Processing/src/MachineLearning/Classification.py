'''
Created on Nov 22, 2011

@author: alex
'''

from MachineLearning.Learner.Learner import Learner
from MachineLearning.Classifier.NaiveBayes import NaiveBayesClassifier
from MachineLearning.Classifier.DecisionTree import DecisionTreeClassifier
from Tools.eval_rte import evaluate
from Tools.FileHandler import FileHandler
from General.PATH import PATH

class Classification:
    
    def __init__(self):
        self.ref_fname = PATH+"file/RTE2_dev.xml"
        self.folder = PATH+"file/Machine_Learning/"
        self.pred_fname = self.folder+"NaiveBayesClassified.txt"
        #self.prediction = self.folder+"RTE2_dev_entailments.txt"
        self.fileWriter = FileHandler()
        
    def getAccuracy(self):
        accuracy = evaluate(self.ref_fname, self.pred_fname)
        print "Accuracy of the prediction by a Naive Bayes Classifier : %4f" % accuracy   
        
    def writeClassifierDecision(self, classifier, featuresets):
        featuresets = sorted(featuresets, key=lambda featureset: int(featureset[0]))
        self.fileWriter.writeFile(self.pred_fname, "ranked: no\n", "w")
        #self.fileWriter.writeFile(self.prediction, "ranked: no\n", "w")
        for featureset in featuresets:
            #self.fileWriter.writeFile(self.prediction, featureset[0]+" "+featureset[1][1]+"\n", "a")
            self.fileWriter.writeFile(self.pred_fname, featureset[0]+" "+classifier.classify(featureset[1][0])+"\n", "a")
        self.getAccuracy()
        
    def classProcessNaiveBayes(self, featuresets, cv = False):
        learner = Learner()
        classifier = None
        if cv:
            classifier = learner.trainingCV(NaiveBayesClassifier.train, [featureset[1] for featureset in featuresets])
        else:
            classifier = learner.training(NaiveBayesClassifier.train, [featureset[1] for featureset in featuresets])
        classifier.show_most_informative_features() 
        self.writeClassifierDecision(classifier, featuresets)
    
    def classProcessNaiveBayesTest(self, featuresets_training, featuresets_test, cv = False):
        learner = Learner()
        classifier = None
        if cv:
            classifier = learner.trainingCV(NaiveBayesClassifier.train, [featureset[1] for featureset in featuresets_training])
        else:
            classifier = learner.training(NaiveBayesClassifier.train, [featureset[1] for featureset in featuresets_training])
        classifier.show_most_informative_features() 
        self.writeClassifierDecision(classifier, featuresets_test)
    
    def f(self, x):
        return DecisionTreeClassifier.train(x, binary=True, verbose=True)  
        
    def classProcessDecisionTree(self, featuresets, cv = False):
        learner = Learner()
        classifier = None
        if cv:
            classifier = learner.trainingCV(self.f,[featureset[1] for featureset in featuresets])
        else:
            classifier = learner.training(self.f,[featureset[1] for featureset in featuresets])
        print classifier.pp(depth=7)
        print classifier.pseudocode(depth=7)
        self.writeClassifierDecision(classifier, featuresets)
