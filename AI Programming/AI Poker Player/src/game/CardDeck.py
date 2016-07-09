import random

# A simple card-deck class
class CardDeck:
    
    def __init__(self, shuffles = 10, rollout = False):
        self._card_value_names_ = [2,3,4,5,6,7,8,9,10,'jack','queen','king','ace']
        self._card_suits_ = {'S':'Spade','H':'Heart','C':'Club','D':'Diamond'} # A dictionary
        if rollout:
            self.reset_rollout()
        else:
            self.shuffle_reps = shuffles
            self.reset()   

    def reset_rollout(self):
        self.cards = self.gen_52_cards()

    def ranking(self,rank):
        return {
          1: lambda:"high card",
          2: lambda:"pair",
          3: lambda:"two pairs",
          4: lambda:"three of a kind",
          5: lambda:"straight",
          6: lambda:"flush",
          7: lambda:"full house",
          8: lambda:"four of a kind",
          9: lambda:"straight flush",
          10:lambda:"royal flush"
        }[rank]() 

    def create_card (self,value, suit): return [value, suit]

    def deal_one_card(self):
        if self.cards:
            return self.cards.pop(0)
        else:
            print "The deck is empty"
            return False

    def deal_n_cards(self,n):
        cards = []
        for i in range(n):
            card = self.deal_one_card()
            if card:
                cards.append(card)
            else:
                print "Not enough cards in the deck"
                return False
        return cards

    def get_all_suits(self):
        return self._card_suits_.keys()
    
    def getQuickCards(self,v,suit):
        return [self.create_card(v,suit),self.create_card(v,suit)]
    
    # Create a list of 52 standard playing cards
    def gen_52_cards(self):
        deck = []
        for suit in self.get_all_suits():
            for v in range(2,15):
                deck.append(self.create_card(v,suit))
        return deck

    # Shuffle a set of cards 'reps number of times
    def shuffle_cards(self,cards, reps = 1):
        for rep in range(reps):
            new_cards = []
            for i in range(len(cards)-1,-1,-1):
                index = random.randint(0,i)
                new_cards.append(cards[index])
                cards[index:index+1] = [] # Removing the indexed item
            cards = new_cards
        return cards

    def gen_52_shuffled_cards(self,reps = 5):
        d = self.gen_52_cards()
        return self.shuffle_cards(d,reps=reps)

    def gen_random_cards(self,count, reps = 5):
        d = self.gen_52_shuffled_cards(reps = reps)
        return d[0:count]

    def reset(self):
        self.cards =  self.gen_52_shuffled_cards(self.shuffle_reps)
        
    def card_value(self, card): return card[0]
    def card_suit(self, card): return card[1]

    def card_value_name(self, card): return self.card_value_to_name(self.card_value(card))
    def card_value_to_name(self, val): return self._card_value_names_[val-2]

    def card_suit_name(self,card): return self._card_suits_[self.card_suit(card)]


    def card_name(self, card): return [self.card_value_name(card), self.card_suit_name(card)]
    def card_names(self, cards): return [self.card_name(c) for c in cards]

    def quick_cards (self, name_suit_list):
        return [self.create_card(spec[0],spec[1]) for spec in name_suit_list]

    def is_jack (self, card): return self.card_value(card) == 11
    def is_queen (self, card): return self.card_value(card) == 12
    def is_king (self, card): return self.card_value(card) == 13
    def is_ace (self, card): return self.card_value(card) == 14

    def remove_cards(self, cards_to_remove):
        for card in self.cards:
            for card_to_remove in cards_to_remove:
                if card_to_remove == card:
                    self.cards.remove(card)

    def isPair(self, cards):
        return cards[0][1] != cards[1][1] and cards[0][0] == cards[1][0]
    
    def isUnsuited(self, cards):
        return cards[0][1] != cards[1][1]
    
    def isSuited(self, cards):
        return cards[0][1] == cards[1][1] and cards[0][0] != cards[1][0]
