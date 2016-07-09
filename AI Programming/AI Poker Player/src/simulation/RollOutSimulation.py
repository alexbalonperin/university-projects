from game.CardDeck import CardDeck
from game.Evaluator import Evaluator
from utilities.Decorators import singleton, controlSimulation
from utilities.FileHandler import FileHandler
import copy
import time

NB_ITERATIONS = 1000
PATH = "../../file/equiv_table.txt"

@singleton
class RollOut:
    
    isSimulating = False
    
    def __init__(self):
        self.nb_players = 9 
        self.nb_eq_class = 169
        self.hole_cards = []
        self.shared_cards = []
        self.opponent_cards = []
        self.suited = 0
        self.unsuited = 1
        self.evaluator = Evaluator()
        self.file_handler = FileHandler()
 
    def computeRollOut(self):
        equiv = self.getHoleCardsEquiv() 
        for eq in equiv:
            wins = losses = ties = 0.0
            self.hole_cards = eq[0]
            for i in range(NB_ITERATIONS):
                deck = CardDeck()
                deck.remove_cards(self.hole_cards)
                self.shared_cards = deck.deal_n_cards(5)
                self.opponent_cards = deck.deal_n_cards(2)
                player_hand_power = self.evaluator.calc_cards_power(self.hole_cards+self.shared_cards, 7)
                opponent_hand_power = self.evaluator.calc_cards_power(self.opponent_cards+self.shared_cards, 7)
                if self.evaluator.card_power_greater(player_hand_power, opponent_hand_power):
                    wins += 1
                elif  self.evaluator.card_power_greater(opponent_hand_power, player_hand_power):
                    losses += 1
                else:
                    ties += 1
            #print wins, losses, ties
            eq = self.calculateProb(wins,losses,ties, eq)
        return equiv

    def getHoleCardsEquiv(self):
        table = []
        deck = CardDeck(rollout = True)
        counter0 = counter1 = counter3 = 2
        counter2 = counter4 = 3
        for card1 in deck.cards:
            self.hole_cards.append(card1)
            if counter4 == 15:
                counter3 += 1
                counter4 = counter3 + 1
            if counter2 == 15:
                counter1 += 1
                counter2 = counter1 + 1
            for card2 in deck.cards:
                if card1 != card2:
                    self.hole_cards.append(card2) 
                    if deck.isPair(self.hole_cards) and self.hole_cards[0][0] == counter0:
                        table.append([copy.copy(self.hole_cards),  [0 for i in range(self.nb_players)]])
                        counter0 += 1
                    elif deck.isSuited(self.hole_cards) and self.hole_cards[0][0] == counter1 and self.hole_cards[1][0] == counter2:
                        table.append([copy.copy(self.hole_cards),  [0 for i in range(self.nb_players)]])
                        counter2 += 1
                    elif deck.isUnsuited(self.hole_cards) and self.hole_cards[0][0] == counter3 and self.hole_cards[1][0] == counter4:
                        table.append([copy.copy(self.hole_cards),  [0 for i in range(self.nb_players)]])
                        counter4 += 1
                    self.hole_cards.remove(card2)
            self.hole_cards.remove(card1)
        return table 
    
    def calculateProb(self, wins, losses, ties,eq):
        for i in range(len(eq[1])):
            eq[1][i] = round(((wins +(ties/2)) /(wins+ties+losses))**(i+2) ,2) 
        return eq
    
    @controlSimulation(isSimulating)
    def simulation(self):
        time_before = time.time()
        equiv_table = self.computeRollOut()
        time_after = time.time()
        diff = time_after - time_before
        print diff
        self.file_handler.dumpToFile(equiv_table,PATH)
        