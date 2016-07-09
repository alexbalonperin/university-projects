'''
Created on Nov 23, 2011

@author: alex
'''
import types

def _mro(cls):
    """
    Return the I{method resolution order} for C{cls} -- i.e., a list
    containing C{cls} and all its base classes, in the order in which
    they would be checked by C{getattr}.  For new-style classes, this
    is just cls.__mro__.  For classic classes, this can be obtained by
    a depth-first left-to-right traversal of C{__bases__}.
    """
    if isinstance(cls, type):
        return cls.__mro__
    else:
        mro = [cls]
        for base in cls.__bases__: mro.extend(_mro(base))
        return mro

def overridden(method):
    """
    @return: True if C{method} overrides some method with the same
    name in a base class.  This is typically used when defining
    abstract base classes or interfaces, to allow subclasses to define
    either of two related methods:

        >>> class EaterI:
        ...     '''Subclass must define eat() or batch_eat().'''
        ...     def eat(self, food):
        ...         if overridden(self.batch_eat):
        ...             return self.batch_eat([food])[0]
        ...         else:
        ...             raise NotImplementedError()
        ...     def batch_eat(self, foods):
        ...         return [self.eat(food) for food in foods]

    @type method: instance method
    """
    # [xx] breaks on classic classes!
    if isinstance(method, types.MethodType) and method.im_class is not None:
        name = method.__name__
        funcs = [cls.__dict__[name]
                 for cls in _mro(method.im_class)
                 if name in cls.__dict__]
        return len(funcs) > 1
    else:
        raise TypeError('Expected an instance method.')
class ClassifierI(object):
    """
    A processing interface for labeling tokens with a single category
    label (or X{class}).  Labels are typically C{string}s or
    C{integer}s, but can be any immutable type.  The set of labels
    that the classifier chooses from must be fixed and finite.

    Subclasses must define:
      - L{labels()}
      - either L{classify()} or L{batch_classify()} (or both)
      
    Subclasses may define:
      - either L{prob_classify()} or L{batch_prob_classify()} (or both)
    """
    def labels(self):
        """
        @return: the list of category labels used by this classifier.
        @rtype: C{list} of (immutable)
        """
        raise NotImplementedError()

    def classify(self, featureset):
        """
        @return: the most appropriate label for the given featureset.
        @rtype: label
        """
        if overridden(self.batch_classify):
            return self.batch_classify([featureset])[0]
        else:
            raise NotImplementedError()

    def prob_classify(self, featureset):
        """
        @return: a probability distribution over labels for the given
            featureset.
        @rtype: L{ProbDistI <nltk.probability.ProbDistI>}
        """
        if overridden(self.batch_prob_classify):
            return self.batch_prob_classify([featureset])[0]
        else:
            raise NotImplementedError()

    def batch_classify(self, featuresets):
        """
        Apply L{self.classify()} to each element of C{featuresets}.  I.e.:

            >>> return [self.classify(fs) for fs in featuresets]

        @rtype: C{list} of I{label}
        """
        return [self.classify(fs) for fs in featuresets]

    def batch_prob_classify(self, featuresets):
        """
        Apply L{self.prob_classify()} to each element of C{featuresets}.  I.e.:

            >>> return [self.prob_classify(fs) for fs in featuresets]

        @rtype: C{list} of L{ProbDistI <nltk.probability.ProbDistI>}
        """
        return [self.prob_classify(fs) for fs in featuresets]