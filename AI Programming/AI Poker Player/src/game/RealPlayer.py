from game.Player import Player

class RealPlayer(Player):
    
    def __init__(self, aggressiveness):
        Player.__init__(self, aggressiveness)
    
    def actions(self, currentBet, deck, players, context, roundActions):
        if self.action == 'c':
            self.call(currentBet)
        elif self.action == 'f':
            self.fold()
        elif self.action == 'r':
            self.betting(currentBet)
        return self.action
            
    def askAction(self):
        while True:
            self.action = raw_input("Choose an action between call, fold and raise (c,f,r)\n")
            if self.action == 'c' or self.action == 'f' or self.action == 'r':
                break
            self.displayer.error("Error: Invalid choice")