from game.Player import Player
from game.Displayer import Displayer
from strength.HandStrength import HandStrength
from strength.WinningProbabilities import WinningProbabilities
from modeler.OpponentModel import OpponentModel

class GoodAI(Player):

    def __init__(self, aggressiveness):
        Player.__init__(self, aggressiveness)
        self.displayer = Displayer()
        self.opp_model = OpponentModel()
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
        
    def chooseActionCons(self, currentBet, my_strength, min_to_bet, min_to_call, strengths):
        self.displayer.debugShowProb(my_strength,min_to_bet,min_to_call)
        if strengths:
            max_strength = max(strengths)
        else:
            max_strength = 1
        if my_strength >= min_to_bet or (my_strength > max_strength and max_strength != -1):
            self.action = 'r'
            self.betting(currentBet)
        elif my_strength > min_to_call or (my_strength >= max_strength and max_strength != -1):
            self.action = 'c'
            self.call(currentBet)
        else:
            self.action = 'f'
            self.fold()
    
    def chooseActionAgg(self, currentBet, my_strength, min_to_bet, min_to_call, strengths):
        self.displayer.debugShowProb(my_strength,min_to_bet,min_to_call)
        avg_strength = 1
        for strength in strengths:
            sum += strength
        if strengths:
            avg_strength = sum/len(strengths)    
        if my_strength >= min_to_bet or (my_strength > avg_strength and avg_strength != -1):
            self.action = 'r'
            self.betting(currentBet)
        elif my_strength > min_to_call or (my_strength > avg_strength and avg_strength != -1):
            self.action = 'c'
            self.call(currentBet)
        else:
            self.action = 'f'
            self.fold()
                
    def decideAction(self, currentBet, cur_context, my_strength, thresholds, players, round_contexts):
        strengths = []
        for context in round_contexts:
            if context.player_nb != cur_context.player_nb:
                strengths.append(self.opp_model.getEstimatedStrength(context))
        if cur_context.nb_players >= 8:
            if self.aggressiveness == 0:
                self.chooseActionCons(currentBet, my_strength,thresholds[0],thresholds[1], strengths)
            else:
                self.chooseActionAgg(currentBet, my_strength,thresholds[0],thresholds[1], strengths)
        elif cur_context.nb_players >= 6:
            if self.aggressiveness == 0:
                self.chooseActionCons(currentBet, my_strength,thresholds[2],thresholds[3], strengths)
            else:
                self.chooseActionAgg(currentBet, my_strength,thresholds[2],thresholds[3], strengths)
        elif cur_context.nb_players >= 4:
            if self.aggressiveness == 0:
                self.chooseActionCons(currentBet, my_strength,thresholds[4],thresholds[5], strengths)
            else:
                self.chooseActionAgg(currentBet, my_strength,thresholds[4],thresholds[5], strengths)
        elif cur_context.nb_players >= 2:
            if self.aggressiveness == 0:
                self.chooseActionCons(currentBet, my_strength,thresholds[6],thresholds[7], strengths)
            else:
                self.chooseActionAgg(currentBet, my_strength,thresholds[6],thresholds[7], strengths) 
        else:
            self.displayer.error("Number of players invalid")
        
    def actions(self, currentBet, deck, players, context, round_contexts):
        if len(context.shared_cards) == 0:
            my_strength = self.winning_prob.getWinningProbability(context.nb_players, self.cards)
            self.decideAction(currentBet, context, my_strength, self.thresholds[:8], players, round_contexts)
        else:
            my_strength  = self.hand_strength.calculateHandStrength(context.shared_cards, context.nb_players, deck, self.cards)
            self.decideAction(currentBet, context, my_strength, self.thresholds[8:], players, round_contexts)
        return self.action
            