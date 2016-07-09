from game.Player import Player
import random
import math

class StupidAI(Player):
    
    def __init__(self, aggressiveness):
        Player.__init__(self, aggressiveness)
        self.thresholds = [3,2,4,3,5,4]
        self.initThresholds()
    
    def initThresholds(self):
        for i in range(len(self.thresholds)):
            if self.thresholds[i] - math.ceil(self.aggressiveness) < 0:
                self.thresholds[i] = 0
            else:
                self.thresholds[i] -= math.ceil(self.aggressiveness)
    
    def askAction(self):
        pass
    
    def actions(self, currentBet, deck, players, context, roundActions):
        if len(context.shared_cards) == 0:
            self.preflopAction(currentBet)
        else:
            power = self.evaluator.calc_cards_power(self.cards+context.shared_cards, len(context.shared_cards)+2)
            self.displayer.showPlayerPower(power)
            if len(context.shared_cards) == 3:
                self.postFlopAction(currentBet, power,self.thresholds[0],self.thresholds[1])
            elif len(context.shared_cards) == 4:
                self.postFlopAction(currentBet, power,self.thresholds[2],self.thresholds[3])
            elif len(context.shared_cards) == 5:
                self.postFlopAction(currentBet, power,self.thresholds[4],self.thresholds[5])
        return self.action

    def preflopAction(self, currentBet):
        rand = random.randint(0,100)
        if rand <= 40:
            self.action = 'c'
            self.call(currentBet)
        elif rand <= 80:
            self.action = 'r'
            self.betting(currentBet)
        else:
            self.action = 'f'
            self.fold()
            
    def postFlopAction(self, currentBet, power, min_to_bet,min_to_call):
        diff = currentBet - self.bet
        if power[0] >= min_to_bet and diff < 50:
            self.action = 'r'
            self.betting(currentBet)
        elif power[0] >= min_to_call and diff < 50:
            self.action = 'c'
            self.call(currentBet)
        else:
            self.action = 'f'
            self.fold()
            
            