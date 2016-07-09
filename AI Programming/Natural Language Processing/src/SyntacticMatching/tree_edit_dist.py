
# -*- coding: utf-8 -*-

#*************************************************************************
#
#     This sample implementation is incomplete!
#     You need to implement the remaining parts yourself.
#
#*************************************************************************
    
"""
Sample implementation of tree edit distance algorithm from 
Kaizhong Zhang & Dennis ShaSha, 
"Simple fast algorithms for the editing distance between trees and related problems",
SIAM Journal on Computing, Vol. 18, No. 6, pp. 1245-1262, 1989.

This is a fairly literal translation of the algorithm described in the paper.
It can probably be improved in several ways, e.g., by avoiding recursion in
the preprocessing.
"""

# EM - 11/2011
from General.Node import Node
from ForestDist import ForestDist
 
def unit_costs(node1, node2):
    """
    Defines unit cost for edit operation on pair of nodes,
    i.e. cost of insertion, deletion, substitution are all 1
    """
    # insertion cost
    if node1 is None:
        return 1
    
    # deletion cost
    if node2 is None:
        return 0
    
    # substitution cost
    if node1.label != node2.label:
        return 1
    else:
        return 0
       
class TreeEditDist():
        
    def postorder(self, root_node):
        """
        Return a list of nodes resulting from a left-to-right postorder traversal
        of the tree rooted in root_node
        """
        # Cf.  Zhang & Shasha:p.1249:
        # "Let T[I] be the ith node in the tree according to the left-to-right
        # postordering"    
        tmp = []
        if not root_node.is_leaf():
            for node in root_node:
                tmp2 = self.postorder(node)
                if type(tmp2) is list:
                    tmp.extend(tmp2)
                else:
                    tmp.append(tmp2)
            tmp.append(root_node)
            return  tmp
        
        else:
            return root_node
        
        
    def leftmost_leaf_descendant_indices(self, node_list):
        """
        Return a list of the *indices* of the leftmost leaf descendants according
        to a list of post-ordered nodes
        """
        # Cf.  Zhang & Shasha:p.1249:
        # "l(i) is the number of the leftmost leaf descendant of the subtree
        # rooted at T[i]. When T[i] is a leaf, l(i)=i."
        def get_leftmost_leaf(node):
            if not node.is_leaf():
                return get_leftmost_leaf(node.left_child())
            else:
                return node
    
        indices = []
        for node in node_list:
            leftmost_node = get_leftmost_leaf(node)
            for i in range(len(node_list)):
                if id(node_list[i]) == id(leftmost_node):
                    indices.append(i)
                    break
        return indices
            
            
    def key_root_indices(self, lld_indices):
        """
        Return a list of the *indices* of the key roots from a list of the indices
        of the leftmost leaf descendants
        """
        # Cf. Zhang & Shasha:p.1251: "LR_keyroots(T) = {k| there exists no k'>k
        # such that l(k)=l(k')}
        def get_number_leafs(lld_indices):
            counter = 0
            for i in range(len(lld_indices)):
                if i == lld_indices[i]:
                    counter = counter + 1
            return counter
        
        kr = [0]*get_number_leafs(lld_indices)
        visited = [False]*len(lld_indices)
        k = len(kr)-1
        i = len(lld_indices)-1
        while k >= 0:
            if not visited[lld_indices[i]]:
                kr[k] = i
                k = k - 1
                visited[lld_indices[i]] = True
            i = i - 1
        return sorted(kr)
        
    def distance(self, t1, t2, costs=unit_costs):
        """
        Compute edit distance between tree t1 and tree t2
        Unit costs are used if no explicit costs are provided.
        """
        #print costs
        #raw_input("pause")
        # Cf. Zhang & Shasha:p.1252-1253
        #===========================================================================
        # Use an embedded function, so T1,T2, l1,l2, and TD are available from the
        # name space of the outer function and don't need to be dragged around in
        # each function call
        # TREEDIST function
        #===========================================================================
        def edit_dist(i, j):
            """
            compute edit distance between two subtrees rooted in nodes i and j
            respectively
            """
            # temporary array for forest distances
            FD = ForestDist()
            for n in range(l1[i], i+1):
                FD[ (l1[i],n), None ] = ( FD[ (l1[i],n-1), None ] + 
                                          costs(T1[n], None) ) #NOT SURE ABOUT THE T1[n].label --> TO BE CHECKED
                
            for m in range(l2[j], j+1):
                FD[ None, (l2[j],m) ] = ( FD[ None, (l2[j],m-1) ] + 
                                          costs(None, T2[m]) )
                
            for n in range(l1[i], i+1):
                for m in range(l2[j], j+1):
                    if l1[n] == l1[i] and l2[m] == l2[j]:
                        FD[ (l1[i],n), (l2[j],m) ] = min(
                                                         FD[(l1[i],n-1),(l2[j],m)] + costs(T1[n], None),
                                                         FD[(l1[i],n),(l2[j],m-1)] + costs(None, T2[m]),
                                                         FD[(l1[i],n-1),(l2[j],m-1)] + costs(T1[n], T2[m]))
                        
                        TD[n, m] = FD[ (l1[i],n), (l2[j],m) ]
                    else:
                        FD[ (l1[i],n), (l2[j],m) ] = min(
                                                         FD[(l1[i],n-1),(l2[j],m)] + costs(T1[n], None),
                                                         FD[(l1[i],n),(l2[j],m-1)] + costs(None, T2[m]),
                                                         FD[(l1[i],n-1),(l2[j],m-1)] + TD[n,m])
            return TD[i,j]
        
        
        #Compute T1[] and T2[]
        T1 = self.postorder(t1)
        T2 = self.postorder(t2)
        
        # Compute l()
        l1 = self.leftmost_leaf_descendant_indices(T1)
        l2 = self.leftmost_leaf_descendant_indices(T2)
        
        # LR_keyroots1 and LR_keyroots2
        kr1 = self.key_root_indices(l1)
        kr2 = self.key_root_indices(l2)
        
        # permanent treedist array
        TD = dict()
        for i in kr1:
            for j in kr2:
                edit_dist(i, j)
                
        #self.print_matrix(T1, T2, TD)
                
        return TD[i,j]        
            
    def print_matrix(self,T1, T2, TD):
        print "   " + "".join([("%-3s" % n.label) for n in T2])
        for i in range(len(T1)):
            print "%-2s" % T1[i].label,
            for j in range(len(T2)):
                print "%-2s" % TD[i,j],
            print
        print

    
        
if __name__ == "__main__":
    #==========================================================================
    # Cf. Zhang & Shasha: Fig. 4 and Fig. 8
    #==========================================================================
    t1 = Node("f",
             Node("d",
                  Node("a"),
                  Node("c",
                       Node("b"))),
             Node("e"))
    
    
    t2 = Node("f",
              Node("c",
                   Node("d",
                        Node("a"),
                        Node("b"))),
              Node("e"))
 
    print "t1 =", t1    
    print "t2 =", t2
    print
    treeEditDist = TreeEditDist()
    d = treeEditDist.distance(t1, t2) 
    print "distance =", d


