'''
Created on Nov 23, 2011

@author: alex
'''
import random, warnings, math
_NINF = float('-1e300')

class ProbDistI(object):
    """
    A probability distribution for the outcomes of an experiment.  A
    probability distribution specifies how likely it is that an
    experiment will have any given outcome.  For example, a
    probability distribution could be used to predict the probability
    that a token in a document will have a given type.  Formally, a
    probability distribution can be defined as a function mapping from
    samples to nonnegative real numbers, such that the sum of every
    number in the function's range is 1.0.  C{ProbDist}s are often
    used to model the probability distribution of the experiment used
    to generate a frequency distribution.
    """
    SUM_TO_ONE = True
    """True if the probabilities of the samples in this probability
       distribution will always sum to one."""
    
    def __init__(self):
        if self.__class__ == ProbDistI:
            raise AssertionError, "Interfaces can't be instantiated"

    def prob(self, sample):
        """
        @return: the probability for a given sample.  Probabilities
            are always real numbers in the range [0, 1].
        @rtype: float
        @param sample: The sample whose probability
               should be returned.
        @type sample: any
        """
        raise AssertionError()

    def logprob(self, sample):
        """
        @return: the base 2 logarithm of the probability for a given
            sample.  Log probabilities range from negitive infinity to
            zero.
        @rtype: float
        @param sample: The sample whose probability
               should be returned.
        @type sample: any
        """
        # Default definition, in terms of prob()
        p = self.prob(sample)
        if p == 0:
            # Use some approximation to infinity.  What this does
            # depends on your system's float implementation.
            return _NINF
        else:
            return math.log(p, 2)

    def max(self):
        """
        @return: the sample with the greatest probability.  If two or
            more samples have the same probability, return one of them;
            which sample is returned is undefined.
        @rtype: any
        """
        raise AssertionError()

    # deprecate this (use keys() instead?)
    def samples(self):
        """
        @return: A list of all samples that have nonzero
            probabilities.  Use C{prob} to find the probability of
            each sample.
        @rtype: C{list}
        """
        raise AssertionError()

    # cf self.SUM_TO_ONE
    def discount(self):
        """
        @return: The ratio by which counts are discounted on average: c*/c
        @rtype: C{float}
        """
        return 0.0

    # Subclasses should define more efficient implementations of this,
    # where possible.
    def generate(self):
        """
        @return: A randomly selected sample from this probability
            distribution.  The probability of returning each sample
            C{samp} is equal to C{self.prob(samp)}.
        """
        p = random.random()
        for sample in self.samples():
            p -= self.prob(sample)
            if p <= 0: return sample
        # allow for some rounding error:
        if p < .0001:
            return sample
        # we *should* never get here
        if self.SUM_TO_ONE:
            warnings.warn("Probability distribution %r sums to %r; generate()"
                          " is returning an arbitrary sample." % (self, 1-p))
        return random.choice(list(self.samples()))