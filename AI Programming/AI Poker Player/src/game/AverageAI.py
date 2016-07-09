from game.Player import Player
from game.Displayer import Displayer
from strength.HandStrength import HandStrength
from strength.WinningProbabilities import WinningProbabilities

class AverageAI(Player):
    
    def __init__(self, aggressiveness):
        Player.__init__(self, aggressiveness)
        self.displayer = Displayer()
        self.hand_strength = HandStrength()
        self.winning_prob = WinningProbabilities()
        self.thresholds = [0.02,0,0.1,0.01,0.3,0.1,0.4,0.2,0.1,0.01,0.14,0.02,0.2,0.05,0.33,0.01]
        self.initThresholds()
    
    def askAction(self):
        pass
    
    def initThresholds(self):
        for i in range(len(self.thresholds)):
            if self.thresholds[i] - self.aggressiveness < 0:
                self.thresholds[i] = 0
            else:
                self.thresholds[i] -= self.aggressiveness
    
    def chooseAction(self, currentBet, strength, min_to_bet, min_to_call):
        self.displayer.debugShowProb(strength,min_to_bet,min_to_call)
        if strength >= min_to_bet:
            self.action = 'r'
            self.betting(currentBet)
        elif strength > min_to_call:
            self.action = 'c'
            self.call(currentBet)
        else:
            self.action = 'f'
            self.fold()
                
    def decideAction(self, currentBet, nb_players, strength , threshold):
        self.displayer.showPlayerPower(strength)
        if nb_players >= 8:
            self.chooseAction(currentBet, strength,threshold[0],threshold[1])
        elif nb_players >= 6:
            self.chooseAction(currentBet, strength,threshold[2],threshold[3])
        elif nb_players >= 4:
            self.chooseAction(currentBet, strength,threshold[4],threshold[5])
        elif nb_players >= 2:
            self.chooseAction(currentBet, strength,threshold[6],threshold[7])
        
    def actions(self, currentBet, deck, players, context, roundActions):
        if len(context.shared_cards) == 0:
            strength = self.winning_prob.getWinningProbability(context.nb_players, self.cards)
            self.displayer.showPlayerPower(strength)
            self.decideAction(currentBet, context.nb_players, strength, self.thresholds[:8])
        else:
            strength  = self.hand_strength.calculateHandStrength(context.shared_cards, context.nb_players, deck, self.cards)
            self.displayer.showPlayerPower(strength)
            self.decideAction(currentBet, context.nb_players, strength, self.thresholds[8:])
        return self.action
