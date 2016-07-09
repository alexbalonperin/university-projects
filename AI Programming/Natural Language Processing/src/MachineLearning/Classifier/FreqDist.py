'''
Created on Nov 23, 2011

@author: alex
'''
class FreqDist(dict):
    """
    A frequency distribution for the outcomes of an experiment.  A
    frequency distribution records the number of times each outcome of
    an experiment has occurred.  For example, a frequency distribution
    could be used to record the frequency of each word type in a
    document.  Formally, a frequency distribution can be defined as a
    function mapping from each sample to the number of times that
    sample occurred as an outcome.

    Frequency distributions are generally constructed by running a
    number of experiments, and incrementing the count for a sample
    every time it is an outcome of an experiment.  For example, the
    following code will produce a frequency distribution that encodes
    how often each word occurs in a text:

        >>> fdist = FreqDist()
        >>> for word in tokenize.whitespace(sent):
        ...    fdist.inc(word.lower())

    An equivalent way to do this is with the initializer:

        >>> fdist = FreqDist(word.lower() for word in tokenize.whitespace(sent))

    """
    def __init__(self, samples=None):
        """
        Construct a new frequency distribution.  If C{samples} is
        given, then the frequency distribution will be initialized
        with the count of each object in C{samples}; otherwise, it
        will be initialized to be empty.

        In particular, C{FreqDist()} returns an empty frequency
        distribution; and C{FreqDist(samples)} first creates an empty
        frequency distribution, and then calls C{update} with the 
        list C{samples}.

        @param samples: The samples to initialize the frequency
        distribution with.
        @type samples: Sequence
        """
        dict.__init__(self)
        self._N = 0
        self._reset_caches()
        if samples:
            print samples
            self.update(samples)

    def inc(self, sample, count=1):
        """
        Increment this C{FreqDist}'s count for the given
        sample.

        @param sample: The sample whose count should be incremented.
        @type sample: any
        @param count: The amount to increment the sample's count by.
        @type count: C{int}
        @rtype: None
        @raise NotImplementedError: If C{sample} is not a
               supported sample type.
        """
        if count == 0: return
        self[sample] = self.get(sample,0) + count

    def __setitem__(self, sample, value):
        """
        Set this C{FreqDist}'s count for the given sample.

        @param sample: The sample whose count should be incremented.
        @type sample: any hashable object
        @param count: The new value for the sample's count
        @type count: C{int}
        @rtype: None
        @raise TypeError: If C{sample} is not a supported sample type.
        """

        self._N += (value - self.get(sample, 0))
        dict.__setitem__(self, sample, value)

        # Invalidate the caches
        self._reset_caches()

    def N(self):
        """
        @return: The total number of sample outcomes that have been
          recorded by this C{FreqDist}.  For the number of unique 
          sample values (or bins) with counts greater than zero, use
          C{FreqDist.B()}.
        @rtype: C{int}
        """
        return self._N

    def B(self):
        """
        @return: The total number of sample values (or X{bins}) that
            have counts greater than zero.  For the total
            number of sample outcomes recorded, use C{FreqDist.N()}.
            (FreqDist.B() is the same as len(FreqDist).)
        @rtype: C{int}
        """
        return len(self)

    # deprecate this -- use keys() instead?
    def samples(self):
        """
        @return: A list of all samples that have been recorded as
            outcomes by this frequency distribution.  Use C{count()}
            to determine the count for each sample.
        @rtype: C{list}
        """
        return self.keys()
    
    def hapaxes(self):
        """
        @return: A list of all samples that occur once (hapax legomena)
        @rtype: C{list}
        """
        return [item for item in self if self[item] == 1]

    def Nr(self, r, bins=None):
        """
        @return: The number of samples with count r.
        @rtype: C{int}
        @type r: C{int}
        @param r: A sample count.
        @type bins: C{int}
        @param bins: The number of possible sample outcomes.  C{bins}
            is used to calculate Nr(0).  In particular, Nr(0) is
            C{bins-self.B()}.  If C{bins} is not specified, it
            defaults to C{self.B()} (so Nr(0) will be 0).
        """
        if r < 0: raise IndexError, 'FreqDist.Nr(): r must be non-negative'

        # Special case for Nr(0):
        if r == 0:
            if bins is None: return 0
            else: return bins-self.B()

        # We have to search the entire distribution to find Nr.  Since
        # this is an expensive operation, and is likely to be used
        # repeatedly, cache the results.
        if self._Nr_cache is None:
            self._cache_Nr_values()

        if r >= len(self._Nr_cache): return 0
        return self._Nr_cache[r]

    def _cache_Nr_values(self):
        Nr = [0]
        for sample in self:
            c = self.get(sample, 0)
            if c >= len(Nr):
                Nr += [0]*(c+1-len(Nr))
            Nr[c] += 1
        self._Nr_cache = Nr

    def count(self, sample):
        """
        Return the count of a given sample.  The count of a sample is
        defined as the number of times that sample outcome was
        recorded by this C{FreqDist}.  Counts are non-negative
        integers.  This method has been replaced by conventional
        dictionary indexing; use fd[item] instead of fd.count(item).

        @return: The count of a given sample.
        @rtype: C{int}
        @param sample: the sample whose count
               should be returned.
        @type sample: any.
        """
        raise AttributeError, "Use indexing to look up an entry in a FreqDist, e.g. fd[item]"

    def _cumulative_frequencies(self, samples=None):
        """
        Return the cumulative frequencies of the specified samples.
        If no samples are specified, all counts are returned, starting
        with the largest.

        @return: The cumulative frequencies of the given samples.
        @rtype: C{list} of C{float}
        @param samples: the samples whose frequencies should be returned.
        @type sample: any.
        """
        cf = 0.0
        if not samples:
            samples = self.keys()
        for sample in samples:
            cf += self[sample]
            yield cf
    
    # slightly odd nomenclature freq() if FreqDist does counts and ProbDist does probs,
    # here, freq() does probs
    def freq(self, sample):
        """
        Return the frequency of a given sample.  The frequency of a
        sample is defined as the count of that sample divided by the
        total number of sample outcomes that have been recorded by
        this C{FreqDist}.  The count of a sample is defined as the
        number of times that sample outcome was recorded by this
        C{FreqDist}.  Frequencies are always real numbers in the range
        [0, 1].

        @return: The frequency of a given sample.
        @rtype: float
        @param sample: the sample whose frequency
               should be returned.
        @type sample: any
        """
        if self._N is 0:
            return 0
        return float(self[sample]) / self._N

    def max(self):
        """
        Return the sample with the greatest number of outcomes in this
        frequency distribution.  If two or more samples have the same
        number of outcomes, return one of them; which sample is
        returned is undefined.  If no outcomes have occurred in this
        frequency distribution, return C{None}.

        @return: The sample with the maximum number of outcomes in this
                frequency distribution.
        @rtype: any or C{None}
        """
        if self._max_cache is None:
            self._max_cache = max([(a,b) for (b,a) in self.items()])[1] 
        return self._max_cache

    

    def sorted_samples(self):
        raise AttributeError, "Use FreqDist.keys(), or iterate over the FreqDist to get its samples in sorted order (most frequent first)"
    
    def sorted(self):
        raise AttributeError, "Use FreqDist.keys(), or iterate over the FreqDist to get its samples in sorted order (most frequent first)"
    
    def _sort_keys_by_value(self):
        if not self._item_cache:
            self._item_cache = sorted(dict.items(self), key=lambda x:(-x[1], x[0]))

    
    def items(self):
        """
        Return the items sorted in decreasing order of frequency.

        @return: A list of items, in sorted order
        @rtype: C{list} of C{tuple}
        """
        self._sort_keys_by_value()
        return self._item_cache[:]
    
    def __iter__(self):
        """
        Return the samples sorted in decreasing order of frequency.

        @return: An iterator over the samples, in sorted order
        @rtype: C{iter}
        """
        return iter(self.keys())

    def iterkeys(self):
        """
        Return the samples sorted in decreasing order of frequency.

        @return: An iterator over the samples, in sorted order
        @rtype: C{iter}
        """
        return iter(self.keys())

    def itervalues(self):
        """
        Return the values sorted in decreasing order.

        @return: An iterator over the values, in sorted order
        @rtype: C{iter}
        """
        return iter(self.values())

    def iteritems(self):
        """
        Return the items sorted in decreasing order of frequency.

        @return: An iterator over the items, in sorted order
        @rtype: C{iter} of any
        """
        self._sort_keys_by_value()
        return iter(self._item_cache)

#        sort the supplied samples
#        if samples:
#            items = [(sample, self[sample]) for sample in set(samples)]

    def copy(self):
        """
        Create a copy of this frequency distribution.
        
        @return: A copy of this frequency distribution object.
        @rtype: C{FreqDist}
        """
        return self.__class__(self)  
    
    def pop(self, other):
        self._reset_caches()
        return dict.pop(self, other)
        
    def popitem(self, other):
        self._reset_caches()
        return dict.popitem(self, other)
        
    def clear(self):
        self._N = 0
        self._reset_caches()
        dict.clear(self)        
    
    def _reset_caches(self):
        self._Nr_cache = None
        self._max_cache = None
        self._item_cache = None
    
    def __add__(self, other):
        clone = self.copy()
        clone.update(other)
        return clone
    def __eq__(self, other):
        if not isinstance(other, FreqDist): return False
        return self.items() == other.items() # items are already sorted
    def __ne__(self, other):
        return not (self == other)
    def __le__(self, other):
        if not isinstance(other, FreqDist): return False
        return set(self).issubset(other) and all(self[key] <= other[key] for key in self)
    def __lt__(self, other):
        if not isinstance(other, FreqDist): return False
        return self <= other and self != other
    def __ge__(self, other):
        if not isinstance(other, FreqDist): return False
        return other <= self
    def __gt__(self, other):
        if not isinstance(other, FreqDist): return False
        return other < self
    
    def __repr__(self):
        """
        @return: A string representation of this C{FreqDist}.
        @rtype: string
        """
        return '<FreqDist with %d outcomes>' % self.N()

    def __str__(self):
        """
        @return: A string representation of this C{FreqDist}.
        @rtype: string
        """
        items = ['%r: %r' % (s, self[s]) for s in self]
        return '<FreqDist: %s>' % ', '.join(items)

    def __getitem__(self, sample):
        return self.get(sample, 0)