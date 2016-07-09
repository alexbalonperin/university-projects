'''
Created on Nov 14, 2011

@author: alex
'''
from Tools.Displayer import *
from Tools.FileHandler import FileHandler
from Tools.eval_rte import evaluate
from General.PATH import PATH
import math

class SimpleOptimizer:

    def __init__(self,textualEntailments, threshold, matcher):
        self.displayer = Displayer()
        self.fileWriter = FileHandler()
        self.ref_fname = PATH+"file/RTE2_dev.xml" 
        self.coeff = (5/2)*0.01  
        self.threshold = threshold
        self.matcher = matcher
    
    def getOptThres(self):
        print "Starting optimisation..."
        min_key = 0
        max_key = 100
        step = 0.01
        steps = 1
        max_value = 0.0
        min_value = 1.0
        threshold = 0
        while step > 1e-5 and (max_value != min_value or step > 1e-3):
            self.fileWriter.emptyFolder(self.matcher.folder)
            my_dict = dict()
            threshold = self.getAccuracy(min_key,max_key,steps,step,my_dict)
            step = step/10
            steps = steps*2
            print my_dict
            keys = self.findMaxes(my_dict, steps, step)
            min_key = int(math.floor(min(keys)))
            max_key = int(math.ceil(max(keys))) 
            if min_key == max_key:
                max_key = int(max_key + self.coeff*steps/step)
                min_key = int(min_key - self.coeff*steps/step)
            print min_key, max_key
            min_value = min(my_dict.values())
            max_value = max(my_dict.values()) 
            if self.threshold != -1:
                break
        self.fileWriter.deleteFilesExceptOne(str(threshold)+".txt", self.matcher.folder) 
        print "The optimal accuracy for the threshold ("+str(threshold)+") is : "+ str(max_value)
        print "Optimisation finished..."
        
    def findMaxes(self,my_dict, steps, step):
        keys = []
        for key in my_dict.iterkeys():
            if my_dict[key] == max(my_dict.values()):
                keys.append(round(key,steps)/step)
        return keys
    
    def getAccuracy(self,min_key,max_key,steps,step,my_dict):
        if self.threshold != -1:
            pred_fname = self.matcher.folder+"/"+str(self.threshold)+".txt"
            self.matcher.getEntailScores(self.threshold, pred_fname)
            accuracy = evaluate(self.ref_fname, pred_fname)
            print "Accuracy of the threshold ("+str(self.threshold)+") : %4f" % accuracy
            my_dict[self.threshold] = accuracy
            return self.threshold
        else:
            thres = 0
            for threshold in range(min_key,max_key,steps):
                thres = threshold*step
                pred_fname = self.matcher.folder+"/"+str(thres)+".txt"
                self.matcher.getEntailScores(thres, pred_fname)
                accuracy = evaluate(self.ref_fname, pred_fname)
                print "Accuracy of the threshold ("+str(thres)+") : %4f" % accuracy
                my_dict[thres] = accuracy
            return thres      