'''
Created on Nov 21, 2011

@author: alex
'''
# Natural Language Toolkit: Naive Bayes Classifiers
#
# Copyright (C) 2001-2011 NLTK Project
# Author: Edward Loper <edloper@gradient.cis.upenn.edu>
# URL: <http://www.nltk.org/>
# For license information, see LICENSE.TXT
#
# $Id: naivebayes.py 2063 2004-07-17 21:02:24Z edloper $

"""
A classifier based on the Naive Bayes algorithm.  In order to find the
probability for a label, this algorithm first uses the Bayes rule to
express P(label|features) in terms of P(label) and P(features|label)::

                      P(label) * P(features|label)
 P(label|features) = ------------------------------
                             P(features)

The algorithm then makes the 'naive' assumption that all features are
independent, given the label::
                             
                      P(label) * P(f1|label) * ... * P(fn|label)
 P(label|features) = --------------------------------------------
                                        P(features)

Rather than computing P(featues) explicitly, the algorithm just
calculates the denominator for each label, and normalizes them so they
sum to one::
                             
                      P(label) * P(f1|label) * ... * P(fn|label)
 P(label|features) = --------------------------------------------
                       SUM[l]( P(l) * P(f1|l) * ... * P(fn|l) )
"""
import math
import random

from collections import defaultdict
from FreqDist import FreqDist
from ClassifierI import ClassifierI
from ProbDistI import ProbDistI
_NINF = float('-1e300')
_ADD_LOGS_MAX_DIFF = math.log(1e-30, 2)

##//////////////////////////////////////////////////////
##  Naive Bayes Classifier
##//////////////////////////////////////////////////////


def sum_logs(logs):
    if len(logs) == 0:
        # Use some approximation to infinity.  What this does
        # depends on your system's float implementation.
        return _NINF
    else:
        return reduce(add_logs, logs[1:], logs[0])



def add_logs(logx, logy):
    """
    Given two numbers C{logx}=M{log(x)} and C{logy}=M{log(y)}, return
    M{log(x+y)}.  Conceptually, this is the same as returning
    M{log(2**(C{logx})+2**(C{logy}))}, but the actual implementation
    avoids overflow errors that could result from direct computation.
    """
    if (logx < logy + _ADD_LOGS_MAX_DIFF):
        return logy
    if (logy < logx + _ADD_LOGS_MAX_DIFF):
        return logx
    base = min(logx, logy)
    return base + math.log(2**(logx-base) + 2**(logy-base), 2)


    
class DictionaryProbDist(ProbDistI):
    """
    A probability distribution whose probabilities are directly
    specified by a given dictionary.  The given dictionary maps
    samples to probabilities.
    """
    def __init__(self, prob_dict=None, log=False, normalize=False):
        """
        Construct a new probability distribution from the given
        dictionary, which maps values to probabilities (or to log
        probabilities, if C{log} is true).  If C{normalize} is
        true, then the probability values are scaled by a constant
        factor such that they sum to 1.
        """
        self._prob_dict = prob_dict.copy()
        self._log = log

        # Normalize the distribution, if requested.
        if normalize:
            if log:
                value_sum = sum_logs(self._prob_dict.values())
                if value_sum <= _NINF:
                    logp = math.log(1.0/len(prob_dict), 2)
                    for x in prob_dict.keys():
                        self._prob_dict[x] = logp
                else:
                    for (x, p) in self._prob_dict.items():
                        self._prob_dict[x] -= value_sum
            else:
                value_sum = sum(self._prob_dict.values())
                if value_sum == 0:
                    p = 1.0/len(prob_dict)
                    for x in prob_dict:
                        self._prob_dict[x] = p
                else:
                    norm_factor = 1.0/value_sum
                    for (x, p) in self._prob_dict.items():
                        self._prob_dict[x] *= norm_factor

    def prob(self, sample):
        if self._log:
            if sample not in self._prob_dict: return 0
            else: return 2**(self._prob_dict[sample])
        else:
            return self._prob_dict.get(sample, 0)

    def logprob(self, sample):
        if self._log:
            return self._prob_dict.get(sample, _NINF)
        else:
            if sample not in self._prob_dict: return _NINF
            elif self._prob_dict[sample] == 0: return _NINF
            else: return math.log(self._prob_dict[sample], 2)

    def max(self):
        if not hasattr(self, '_max'):
            self._max = max((p,v) for (v,p) in self._prob_dict.items())[1]
        return self._max
    def samples(self):
        return self._prob_dict.keys()
    def __repr__(self):
        return '<ProbDist with %d samples>' % len(self._prob_dict)



class LidstoneProbDist(ProbDistI):
    """
    The Lidstone estimate for the probability distribution of the
    experiment used to generate a frequency distribution.  The
    C{Lidstone estimate} is paramaterized by a real number M{gamma},
    which typically ranges from 0 to 1.  The X{Lidstone estimate}
    approximates the probability of a sample with count M{c} from an
    experiment with M{N} outcomes and M{B} bins as
    M{(c+gamma)/(N+B*gamma)}.  This is equivalant to adding
    M{gamma} to the count for each bin, and taking the maximum
    likelihood estimate of the resulting frequency distribution.
    """
    SUM_TO_ONE = False
    def __init__(self, freqdist, gamma, bins=None):
        """
        Use the Lidstone estimate to create a probability distribution
        for the experiment used to generate C{freqdist}.

        @type freqdist: C{FreqDist}
        @param freqdist: The frequency distribution that the
            probability estimates should be based on.
        @type gamma: C{float}
        @param gamma: A real number used to paramaterize the
            estimate.  The Lidstone estimate is equivalant to adding
            M{gamma} to the count for each bin, and taking the
            maximum likelihood estimate of the resulting frequency
            distribution.
        @type bins: C{int}
        @param bins: The number of sample values that can be generated
            by the experiment that is described by the probability
            distribution.  This value must be correctly set for the
            probabilities of the sample values to sum to one.  If
            C{bins} is not specified, it defaults to C{freqdist.B()}.
        """
        if (bins == 0) or (bins is None and freqdist.N() == 0):
            name = self.__class__.__name__[:-8]
            raise ValueError('A %s probability distribution ' % name +
                             'must have at least one bin.')
        if (bins is not None) and (bins < freqdist.B()):
            name = self.__class__.__name__[:-8]
            raise ValueError('\nThe number of bins in a %s distribution ' % name +
                             '(%d) must be greater than or equal to\n' % bins +
                             'the number of bins in the FreqDist used ' +
                             'to create it (%d).' % freqdist.N())

        self._freqdist = freqdist
        self._gamma = float(gamma)
        self._N = self._freqdist.N()

        if bins is None: bins = freqdist.B()
        self._bins = bins

        self._divisor = self._N + bins * gamma
        if self._divisor == 0.0:
            # In extreme cases we force the probability to be 0,
            # which it will be, since the count will be 0:
            self._gamma = 0
            self._divisor = 1

    def freqdist(self):
        """
        @return: The frequency distribution that this probability
            distribution is based on.
        @rtype: C{FreqDist}
        """        
        return self._freqdist

    def prob(self, sample):
        c = self._freqdist[sample]
        return (c + self._gamma) / self._divisor

    def max(self):
        # For Lidstone distributions, probability is monotonic with
        # frequency, so the most probable sample is the one that
        # occurs most frequently.
        return self._freqdist.max()

    def samples(self):
        return self._freqdist.keys()

    def discount(self):
        gb = self._gamma * self._bins
        return gb / (self._N + gb)

    def __repr__(self):
        """
        @rtype: C{string}
        @return: A string representation of this C{ProbDist}.
        """
        return '<LidstoneProbDist based on %d samples>' % self._freqdist.N()



class ELEProbDist(LidstoneProbDist):
    """
    The expected likelihood estimate for the probability distribution
    of the experiment used to generate a frequency distribution.  The
    X{expected likelihood estimate} approximates the probability of a
    sample with count M{c} from an experiment with M{N} outcomes and
    M{B} bins as M{(c+0.5)/(N+B/2)}.  This is equivalant to adding 0.5
    to the count for each bin, and taking the maximum likelihood
    estimate of the resulting frequency distribution.
    """    
    def __init__(self, freqdist, bins=None):
        """
        Use the expected likelihood estimate to create a probability
        distribution for the experiment used to generate C{freqdist}.

        @type freqdist: C{FreqDist}
        @param freqdist: The frequency distribution that the
            probability estimates should be based on.
        @type bins: C{int}
        @param bins: The number of sample values that can be generated
            by the experiment that is described by the probability
            distribution.  This value must be correctly set for the
            probabilities of the sample values to sum to one.  If
            C{bins} is not specified, it defaults to C{freqdist.B()}.
        """
        LidstoneProbDist.__init__(self, freqdist, 0.5, bins)

    def __repr__(self):
        """
        @rtype: C{string}
        @return: A string representation of this C{ProbDist}.
        """
        return '<ELEProbDist based on %d samples>' % self._freqdist.N()


class NaiveBayesClassifier(ClassifierI):
    """
    A Naive Bayes classifier.  Naive Bayes classifiers are
    paramaterized by two probability distributions:

      - P(label) gives the probability that an input will receive each
        label, given no information about the input's features.
        
      - P(fname=fval|label) gives the probability that a given feature
        (fname) will receive a given value (fval), given that the
        label (label).

    If the classifier encounters an input with a feature that has
    never been seen with any label, then rather than assigning a
    probability of 0 to all labels, it will ignore that feature.

    The feature value 'None' is reserved for unseen feature values;
    you generally should not use 'None' as a feature value for one of
    your own features.
    """
    def __init__(self, label_probdist, feature_probdist):
        """
        @param label_probdist: P(label), the probability distribution
            over labels.  It is expressed as a L{ProbDistI} whose
            samples are labels.  I.e., P(label) =
            C{label_probdist.prob(label)}.
        
        @param feature_probdist: P(fname=fval|label), the probability
            distribution for feature values, given labels.  It is
            expressed as a dictionary whose keys are C{(label,fname)}
            pairs and whose values are L{ProbDistI}s over feature
            values.  I.e., P(fname=fval|label) =
            C{feature_probdist[label,fname].prob(fval)}.  If a given
            C{(label,fname)} is not a key in C{feature_probdist}, then
            it is assumed that the corresponding P(fname=fval|label)
            is 0 for all values of C{fval}.
        """
        self._label_probdist = label_probdist
        self._feature_probdist = feature_probdist
        self._labels = label_probdist.samples()

    def labels(self):
        return self._labels

    def classify(self, featureset):
        return self.prob_classify(featureset).max()
        
    def prob_classify(self, featureset):
        # Discard any feature names that we've never seen before.
        # Otherwise, we'll just assign a probability of 0 to
        # everything.
        featureset = featureset.copy()
        for fname in featureset.keys():
            for label in self._labels:
                if (label, fname) in self._feature_probdist:
                    break
            else:
                #print 'Ignoring unseen feature %s' % fname
                del featureset[fname]

        # Find the log probabilty of each label, given the features.
        # Start with the log probability of the label itself.
        logprob = {}
        for label in self._labels:
            logprob[label] = self._label_probdist.logprob(label)
            
        # Then add in the log probability of features given labels.
        for label in self._labels:
            for (fname, fval) in featureset.items():
                if (label, fname) in self._feature_probdist:
                    feature_probs = self._feature_probdist[label,fname]
                    logprob[label] += feature_probs.logprob(fval)
                else:
                    # nb: This case will never come up if the
                    # classifier was created by
                    # NaiveBayesClassifier.train().
                    logprob[label] += self.sum_logs([]) # = -INF.
                    
        return DictionaryProbDist(logprob, normalize=True, log=True)

    def show_most_informative_features(self, n=10):
        # Determine the most relevant features, and display them.
        cpdist = self._feature_probdist
        print 'Most Informative Features'

        for (fname, fval) in self.most_informative_features(n):
            def labelprob(l):
                return cpdist[l,fname].prob(fval)
            labels = sorted([l for l in self._labels
                             if fval in cpdist[l,fname].samples()],
                            key=labelprob)
            if len(labels) == 1: continue
            l0 = labels[0]
            l1 = labels[-1]
            if cpdist[l0,fname].prob(fval) == 0:
                ratio = 'INF'
            else:
                ratio = '%8.1f' % (cpdist[l1,fname].prob(fval) /
                                  cpdist[l0,fname].prob(fval))
            print ('%24s = %-14r %6s : %-6s = %s : 1.0' %
                   (fname, fval, str(l1)[:6], str(l0)[:6], ratio))
    
    def most_informative_features(self, n=100):
        """
        Return a list of the 'most informative' features used by this
        classifier.  For the purpose of this function, the
        informativeness of a feature C{(fname,fval)} is equal to the
        highest value of P(fname=fval|label), for any label, divided by
        the lowest value of P(fname=fval|label), for any label::

          max[ P(fname=fval|label1) / P(fname=fval|label2) ]
        """
        # The set of (fname, fval) pairs used by this classifier.
        features = set()
        # The max & min probability associated w/ each (fname, fval)
        # pair.  Maps (fname,fval) -> float.
        maxprob = defaultdict(lambda: 0.0)
        minprob = defaultdict(lambda: 1.0)

        for (label, fname), probdist in self._feature_probdist.items():
            for fval in probdist.samples():
                feature = (fname, fval)
                features.add( feature )
                p = probdist.prob(fval)
                maxprob[feature] = max(p, maxprob[feature])
                minprob[feature] = min(p, minprob[feature])
                if minprob[feature] == 0:
                    features.discard(feature)

        # Convert features to a list, & sort it by how informative
        # features are.
        features = sorted(features, 
            key=lambda feature: minprob[feature]/maxprob[feature])
        return features[:n]

    @staticmethod
    def train(labeled_featuresets, estimator=ELEProbDist):
        """
        @param labeled_featuresets: A list of classified featuresets,
            i.e., a list of tuples C{(featureset, label)}.
        """
        label_freqdist = FreqDist()
        feature_freqdist = defaultdict(FreqDist)
        feature_values = defaultdict(set)
        fnames = set()

        # Count up how many times each feature value occured, given
        # the label and featurename.
        for featureset, label in labeled_featuresets:
            label_freqdist.inc(label)
            for fname, fval in featureset.items():
                # Increment freq(fval|label, fname)
                feature_freqdist[label, fname].inc(fval)
                # Record that fname can take the value fval.
                feature_values[fname].add(fval)
                # Keep a list of all feature names.
                fnames.add(fname)

        # If a feature didn't have a value given for an instance, then
        # we assume that it gets the implicit value 'None.'  This loop
        # counts up the number of 'missing' feature values for each
        # (label,fname) pair, and increments the count of the fval
        # 'None' by that amount.
        for label in label_freqdist:
            num_samples = label_freqdist[label]
            for fname in fnames:
                count = feature_freqdist[label, fname].N()
                feature_freqdist[label, fname].inc(None, num_samples-count)
                feature_values[fname].add(None)

        # Create the P(label) distribution
        label_probdist = estimator(label_freqdist)

        # Create the P(fval|label, fname) distribution
        feature_probdist = {}
        for ((label, fname), freqdist) in feature_freqdist.items():
            probdist = estimator(freqdist, bins=len(feature_values[fname]))
            feature_probdist[label,fname] = probdist

        return NaiveBayesClassifier(label_probdist, feature_probdist)



##//////////////////////////////////////////////////////
##  Demo
##//////////////////////////////////////////////////////

def accuracy(classifier, gold):
    results = classifier.batch_classify([fs for (fs,l) in gold])
    correct = [l==r for ((fs,l), r) in zip(gold, results)]
    if correct:
        return float(sum(correct))/len(correct)
    else:
        return 0

def names_demo_features(name):
    features = {}
    features['alwayson'] = True
    features['startswith'] = name[0].lower()
    features['endswith'] = name[-1].lower()
    for letter in 'abcdefghijklmnopqrstuvwxyz':
        features['count(%s)' % letter] = name.lower().count(letter)
        features['has(%s)' % letter] = letter in name.lower()
    return features

def names_demo(trainer, features=names_demo_features):


    #==========================================================================
    # Construct a list of classified names, using the names corpus.
    #==========================================================================
    namelist = ([(name, 'male') for name in ["Alex","Jean","Fred","Patrick","Tarik","Sylvain"]] + 
                [(name, 'female') for name in ["Maike","Jette","Audrey","Thekla","Anissia","Julie"]])

    # Randomly split the names into a test & train set.
    random.seed(123456)
    random.shuffle(namelist)
    train = namelist[:700]
    test = namelist[700:800]

    # Train up a classifier.
    print 'Training classifier...'
    feature = [(features(n), g) for (n,g) in train]
    print feature
    classifier = trainer( feature )

    # Run the classifier on the test data.
    print 'Testing classifier...'
    acc = accuracy(classifier, [(features(n), g) for (n,g) in test])
    print 'Accuracy: %6.4f' % acc

    # For classifiers that can find probabilities, show the log
    # likelihood and some sample probability distributions.
    #===========================================================================
    # try:
    #    test_featuresets = [features(n) for (n,g) in test]
    #    pdists = classifier.batch_prob_classify(test_featuresets)
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
    #===========================================================================
    
    # Return the classifier
    return classifier
def demo():
    classifier = names_demo(NaiveBayesClassifier.train)
    classifier.show_most_informative_features()
    
if __name__ == '__main__':
    demo()
