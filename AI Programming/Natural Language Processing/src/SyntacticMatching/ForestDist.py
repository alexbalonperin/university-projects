'''
Created on Nov 20, 2011

@author: alex
'''
class ForestDist(dict):
    """
    ForestDist is a dictionary storing the distance between two forest.

    Keys are tuples of the form (forest1, forest2)

    forest1 is either a tuple (i1,j2) where
    i1 = start index of source forest1 and
    j1 = end index of source forest1,
    or None (i.e. empty forest)
    
    Likewise forest2 is either a tuple (i2,j2) where 
    i2 = start index of target forest2 and
    j2 = end index of target forest2,
    or None (i.e. empty forest).
    
    Values are distances >= 0.
    
    By definition, 
    ForestDist(None,None) = 0 and
    forest (i,j) = None when i>j.
    """
    
    def __init__(self,*args, **kwargs):
        dict.__init__(self, *args, **kwargs)
        # forestdist(empty,empty) = 0
        # (cf. Zhang & Shasha:p.1253)
        self[None,None] = 0
        
    def __getitem__(self, (forest1, forest2)):
        # If i>j, then T[i..j] = 0
        # (cf. Zhang & Shasha:p.1249)
        if forest1 is not None:
            i1, j1 = forest1
            if i1 > j1:
                forest1 = None
                
        if forest2 is not None:
            i2, j2 = forest2
            if i2 > j2:
                forest2 = None
                
        return dict.__getitem__(self, (forest1, forest2))