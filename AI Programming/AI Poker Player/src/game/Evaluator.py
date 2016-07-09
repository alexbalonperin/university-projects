from CardDeck import CardDeck

class Evaluator:

    def __init__(self):
        self.deck = CardDeck()

    # Group a set of cards by value
    def gen_value_groups(self,cards):
        new_cards = self.copy_cards(cards)
        return self.sorted_partition(new_cards,elem_prop = (lambda c: self.deck.card_value(c)))

    # Group a set of cards by suit
    def gen_suit_groups(self, cards):
        new_cards = self.copy_cards(cards)
        return self.sorted_partition(new_cards,elem_prop = (lambda c: self.deck.card_suit(c)))

    # Sort a set of cards in ascending or descending order, based on the card value (e.g. 3,7,queen,ace, etc.)
    def gen_ordered_cards(self, cards, dir = 'increase'):
        new_cards = self.copy_cards(cards)
        self.kd_sort(new_cards,prop_func=(lambda c: self.deck.card_value(c)),dir = dir)
        return new_cards

    # Sorting cards

    # Auxiliary funcs copied from prims/prims1.py

    def find_list_item(self, L,item,key=(lambda x: x)):
        for x in L:
            if item == key(x):
                return x

    def kd_sort(self, elems, prop_func = (lambda x: x), dir = 'increase'):
        elems.sort(key=prop_func) # default of the sort func is increasing order
        if dir =='decrease' or dir =='decr':
            elems.reverse()

    # This groups a set of elements by shared values of a specified property (which is determined by
    # prop_func), where the equality of two values is determined by eq_func.  For example, this might
    # be used to group a set of cards by card-value.  Then all the 5's would be returned as one group, all
    # the queens as another, etc.

    def partition(self, elems, prop_func = (lambda x:x), eq_func = (lambda x,y: x == y)):
        self.kd_sort(elems,prop_func=prop_func)
        partition = []
        subset = False
        last_key = False
        for elem in elems:
            new_key = apply(prop_func, [elem])
            if not(subset) or not(apply(eq_func,[last_key,new_key])):
                if subset: partition.append(subset)
                subset = [elem]
                last_key = new_key
            else: subset.append(elem)
        if subset: partition.append(subset)
        return partition

    # This partitions elements and then sorts the groups by the subset_prop function, which defaults to group size.
    # Thus, using the defaults, the largest groups would be at the beginning of the sorted partition.

    def sorted_partition(self, elems,elem_prop = (lambda x:x), subset_prop = (lambda ss: len(ss)), eq_func = (lambda x,y: x ==y), dir = "decrease"):
        p = self.partition(elems,prop_func = elem_prop, eq_func = eq_func)
        self.kd_sort(p,prop_func = subset_prop,dir = dir)
        return p

    def sort_cards(self, cards, prop_func = (lambda c:  c[0]), dir = 'decrease'):
        self.kd_sort(cards,prop_func=prop_func,dir=dir)

    # This is the most important function in this file.  It takes a set of cards and computes
    # their power rating, which is a list of integers, the first of which indicates the type of
    # hand: 9 - straight flush, 8 - 4 of a kind, 7 - full house, 6 - flush, 5 - straight, 4 - 3 of  kind
    # 3 - two pair, 2 - one pair, 1 - high card.  The remaining integers are tie-breaker information
    # required in cases where, for example, two players both have a full house.

    def calc_cards_power (self, cards, target_len = 5):

        def has_len (length, items): return length == len(items)

        vgroups = self.gen_value_groups(cards)
        flush = self.find_flush(cards, target_len = target_len)
        if flush:
            str_in_flush = self.find_straight(flush,target_len = target_len)
        if flush and str_in_flush:
            return self.calc_straight_flush_power(str_in_flush)
        elif has_len(4, vgroups[0]):
            return self.calc_4_kind_power(vgroups)
        elif has_len(3, vgroups[0]) and len(vgroups) > 1 and len(vgroups[1]) >= 2: 
            return self.calc_full_house_power(vgroups)
        elif flush:
            return self.calc_simple_flush_power(flush)
        else:
            straight = self.find_straight(cards)
            if straight:
                return self.calc_straight_power(straight)
            elif has_len(3,vgroups[0]):
                return self.calc_3_kind_power(vgroups)
            elif has_len(2,vgroups[0]):
                if len(vgroups) > 1 and has_len(2,vgroups[1]):
                    return self.calc_2_pair_power(vgroups)
                else: return self.calc_pair_power(vgroups)
            else: return self.calc_high_card_power(cards)

    def card_power_greater(self, p1,p2): # Both are power ratings = lists of power integers returned by calc_cards_power
        if not(p1) or not(p2):
            return False
        elif p1[0] == p2[0]:
            return self.card_power_greater(p1[1:],p2[1:])
        elif p1[0] > p2[0]:
            return True
        else: return False

    # Functions for finding flushes and straights in a set of cards (of any length)

    def find_flush(self, cards, target_len = 5):
        sgroups = self.gen_suit_groups(cards)
        if len(sgroups[0]) >= target_len:
            return sgroups[0]
        else: return False

    def find_straight(self, cards, target_len = 5):
        ace = self.find_list_item(cards,14,key=(lambda c: self.deck.card_value(c)))
        scards = self.gen_ordered_cards(cards, dir = 'decrease')

        def scan(cards, straight):
            if len(straight) == target_len:
                return straight
            elif ace and 2 == self.deck.card_value(straight[0]) and len(straight) == target_len - 1:
                return [ace] + straight
            elif not(cards):
                return False # null check is late since variable 'cards not involved in 1st 2 cases
           
            c = cards.pop(0)
            if self.deck.card_value(c) == (self.deck.card_value(straight[0]) - 1):
                return scan(cards,[c] + straight)
            elif self.deck.card_value(c) == self.deck.card_value(straight[0]):
                return scan(cards,straight)
            else: # Broken straight, so start again with the current card
                return scan(cards,[c])

        top_card = scards.pop(0)
        return scan(scards,[top_card])

    # Simple auxiliary function for finding and sorting all card values in a set of card groups, and then returning
    # the largest 'count of them.
    def max_group_vals(self, groups,count):
        vals = [self.deck.card_value(g[0]) for g in groups]
        self.kd_sort(vals,dir='decrease')
        return vals[0:count]
       

    # Straights are presumably sorted in ASCENDING order
    def calc_straight_flush_power(self, straight):
        return [9,self.deck.card_value(straight[-1])]

    def calc_4_kind_power(self, value_groups):
        return [8,self.deck.card_value(value_groups[0][0])] + self.max_group_vals(value_groups[1:],1)

    def calc_full_house_power(self, value_groups):
        return [7] + [self.deck.card_value(vg[0]) for vg in value_groups[0:2]]

    def calc_simple_flush_power(self, flush, target_len = 5):
        new_flush = self.copy_cards(flush)
        self.sort_cards(new_flush)
        return [6] + [self.deck.card_value(c) for c in new_flush[0:target_len]]

    def calc_straight_power(self, straight):
        return [5,self.deck.card_value(straight[-1])]

    def calc_3_kind_power(self, value_groups):
        return [4,self.deck.card_value(value_groups[0][0])] + self.max_group_vals(value_groups[1:],2)


    def calc_2_pair_power(self, value_groups):
        return [3,self.deck.card_value(value_groups[0][0]),self.deck.card_value(value_groups[1][0])] + self.max_group_vals(value_groups[2:],1)

    def calc_pair_power(self, value_groups):
        return [2,self.deck.card_value(value_groups[0][0])] + self.max_group_vals(value_groups[1:],3)

    def calc_high_card_power(self, cards):
        ocards = self.gen_ordered_cards(cards,dir='decrease')
        return [1] + [self.deck.card_value(c) for c in ocards][0:5]

    # The basic card data structure: a 2-element list
    def card_eq (self, c1, c2):
        return self.deck.card_value(c1) == self.deck.card_value(c2) and self.deck.card_suit(c1) == self.deck.card_suit(c2)

    def copy_card(self, c): return self.deck.create_card(self.deck.card_value(c),self.deck.card_suit(c))
    def copy_cards(self, cards): return [self.copy_card(c) for c in cards]

    # Main routine for testing the generation and classification (via power ratings) of many poker hands.
        
    def power_test(self, hands, hand_size = 7):
        for i in range(hands):
            deck = self.card_deck()
            cards = deck.deal_n_cards(hand_size)
            print "Hand: " , self.card_names(cards), '  Power: ', self.calc_cards_power(cards)        
        