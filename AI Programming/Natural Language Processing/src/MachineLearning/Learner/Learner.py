'''
Created on Nov 22, 2011

@author: alex
'''
import random,math

class Learner:
    def training(self, trainer, features):
    
        # Construct a list of classified names, using the names corpus.
        #namelist = ([(name, 'male') for name in ["Alex","Jean","Fred","Patrick","Tarik","Sylvain"]] + 
        #            [(name, 'female') for name in ["Maike","Jette","Audrey","Thekla","Anissia","Julie"]])
    
        # Randomly split the names into a test & train set.
        random.seed(123456)
        random.shuffle(features)
        train = features[:700]
        test = features[700:800]
    
        # Train up a classifier.
        print 'Training classifier...'
        #feature = [(features(n), g) for (n,g) in train]
        classifier = trainer(train)
    
        # Run the classifier on the test data.
        print 'Testing classifier...'
        acc = self.classifierAccuracy(classifier, test)
        print 'Accuracy: %6.4f' % acc
    
        #=======================================================================
        # For classifiers that can find probabilities, show the log
        # likelihood and some sample probability distributions.
        #=======================================================================
        """
            send the textualEntailments to calculate the log likelihood
        """
        #=======================================================================
        # try: 
        #    pdists = classifier.batch_prob_classify(test)
        #    ll = [pdist.logprob(gold)
        #          for ((name, gold), pdist) in zip(test, pdists)]
        #    print 'Avg. log likelihood: %6.4f' % (sum(ll)/len(test))
        #    print
        #    print 'Unseen Names      P(Male)  P(Female)\n'+'-'*40
        #    for ((name, gender), pdist) in zip(test, pdists)[:5]:
        #        if gender == 'male':
        #            fmt = '  %-15s *%6.4f   %6.4f'
        #        else:
        #            fmt = '  %-15s  %6.4f  *%6.4f'
        #        print fmt % (name, pdist.prob('male'), pdist.prob('female'))
        # except NotImplementedError:
        #    pass
        #=======================================================================
        
        # Return the classifier
        return classifier
    
    def trainingCV(self, trainer, features):
    
        # Construct a list of classified names, using the names corpus.
        #namelist = ([(name, 'male') for name in ["Alex","Jean","Fred","Patrick","Tarik","Sylvain"]] + 
        #            [(name, 'female') for name in ["Maike","Jette","Audrey","Thekla","Anissia","Julie"]])
    
        # Randomly split the names into a test & train set.
        random.seed(123456)
        random.shuffle(features)
        size_cv = int(math.floor(len(features)/10))
        acc = []
        nb_folds = 10
        for i in range(1,nb_folds):
            test = features[((i-1)*size_cv):(i*size_cv-1)]
            train = [feature for feature in features if feature not in test]
            classifier = trainer(train)
            acc.append(self.classifierAccuracy(classifier, test))
        
        print 'Accuracy: %6.4f' % (sum(acc, 0.0) / len(acc)  )
        return classifier

    def classifierAccuracy(self, classifier, gold):
        results = classifier.batch_classify([fs for (fs,l) in gold])
        correct = [l==r for ((fs,l), r) in zip(gold, results)]
        if correct:
            return float(sum(correct))/len(correct)
        else:
            return 0 
        