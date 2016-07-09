from game.Evaluator import Evaluator

class HandStrength:
    
    def __init__(self):
        self.evaluator = Evaluator()
    
    def calculateHandStrength(self, shared_cards, nb_players, deck, cards):
        my_power = self.evaluator.calc_cards_power(cards+shared_cards, len(shared_cards)+2)
        wins = losses = ties = 0.0
        for card1 in deck.cards:
            for card2 in deck.cards:
                if card1 != card2:
                    opponent_cards = [card1, card2]
                    opp_power = self.evaluator.calc_cards_power(opponent_cards+shared_cards, len(shared_cards)+2)
                    if self.evaluator.card_power_greater(my_power, opp_power):      wins += 1
                    elif self.evaluator.card_power_greater(opp_power, my_power):    losses += 1
                    else:                                                           ties += 1        
        return ((wins +(ties/2)) /(wins+ties+losses))**(nb_players+2)
    
    def effectiveHandStrength(self, shared_cards, nb_players, deck, cards):
        my_power = self.evaluator.calc_cards_power(cards+shared_cards, len(shared_cards)+2)
        wins = losses = ties = 0.0
        ahead = 0
        tied = 1
        behind = 2
        index = 0
        HP = [[ 0 for i in range(3)]for j in range(3)]
        HPTotal = [0 for i in range(3)]
        for card1 in deck.cards:
            for card2 in deck.cards:
                if card1 != card2:
                    opponent_cards = [card1, card2]
                    opp_power = self.evaluator.calc_cards_power(opponent_cards+shared_cards, len(shared_cards)+2)
                    if self.evaluator.card_power_greater(my_power, opp_power):      wins += 1; index = ahead 
                    elif self.evaluator.card_power_greater(opp_power, my_power):    losses += 1; index = behind
                    else:                                                           ties += 1; index = tied 
                    HPTotal[index] += 1
                    if len(shared_cards) == 3:
                        for turn in deck.cards:
                            for river in deck.cards:
                                if turn != river and turn != card2 and turn != card2 and river != card2 and river != card1:
                                    board = shared_cards+turn+river
                                    my_power = self.evaluator.calc_cards_power(cards+board, len(shared_cards)+4)
                                    opp_power = self.evaluator.calc_cards_power(opponent_cards+board, len(shared_cards)+4)
                                    if self.evaluator.card_power_greater(my_power, opp_power):      HP[index][ahead] += 1
                                    elif self.evaluator.card_power_greater(opp_power, my_power):    HP[index][behind] += 1
                                    else:                                                           HP[index][tied] += 1 
        p_pot = (HP[behind][ahead]+HP[behind][tied]/2 + HP[tied][ahead]/2)/(HPTotal[behind]+HPTotal[tied])
        hand_strength = ((wins +(ties/2)) /(wins+ties+losses))**(nb_players+2)
        effective_hand_strength = hand_strength + (1 - hand_strength)*p_pot
        return effective_hand_strength
    
    