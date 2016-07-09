from utilities.Decorators import controlDisplay, debugging

class Displayer:
    simulation = True
    debug = False
    modelling = False
    
    @debugging(debug)
    def debugShowProb(self, prob, min_to_bet, min_to_call):
        print "Prob = ",prob, " Min_to_bet = ", min_to_bet," Min_to_call = ", min_to_call
    
    @debugging(debug)
    def debugRanking(self, players, winner, shared_cards):
        print players[winner].cards+shared_cards
        print len(shared_cards)+2
    
    @controlDisplay(simulation)
    def showWinner(self, winner, rank):
        self.display("WINNER")
        print "Player", winner.number, "wins with: ", rank
        print "    money:",winner.money
        self.printStarline()
    
    @controlDisplay(simulation)
    def pause(self):
        raw_input("Press a key to continue...\n\n")
        
    def welcome(self):
        self.printStarline()
        self.printStarline()
        print "                           POKER GAME"
        self.printStarline()
        self.printStarline()
        print("    Welcome to this poker game!\n    We hope you will enjoy it as much as we do...")
        self.printLine()
    
    def goodbye(self):
        print("Thank you for playing. See you soon!")
    
    @controlDisplay(simulation)
    def display(self, value):
        self.printStarline()
        print value
        self.printLine()
    
    @controlDisplay(simulation)
    def displayRoundNumber(self,betRound):
        self.printStarline()
        print "Round of betting number", betRound
        self.printStarline()
       
    @controlDisplay(simulation) 
    def showSharedCards(self, shared_cards):
        print "Common cards : ", shared_cards
    
    @controlDisplay(simulation)
    def showPlayerCards(self, players, turn):
        print "Player", players[turn].number,"\n    cards:", players[turn].cards
    
    @controlDisplay(simulation)
    def showPlayerPower(self, power):
        print "    power:", power
    
    @controlDisplay(simulation)
    def showPlayerAction(self, players, turn):
        print "    action:", players[turn].action
        if players[turn].action != 'f':
            print "    bet:", players[turn].bet, "\n"
    
    @controlDisplay(simulation)
    def showBlinds(self, players, small_blind, big_blind, rand, nb_players):
        print  "Player ", players[rand].number," plays small blind (", small_blind,") and Player ", players[(rand+1)%nb_players].number," plays small blind (",big_blind,")\n"

    @controlDisplay(simulation)
    def showTable(self, pot, shared_cards, players):
        self.display("TABLE")
        print "Pot:", pot 
        self.showSharedCards(shared_cards)
        i = 0
        while i < len(players):
            print "Player", players[i].number, "\n    cards :", players[i].cards, "\n    money:",players[i].money, "\n"
            i+=1
        self.pause()
    
    @controlDisplay(simulation)
    def showCurrentBet(self, cur_bet):
        print "Current bet: ", cur_bet
    
    @controlDisplay(simulation)
    def showPlayerMoney(self, number, money):
        print "    money = ", money
    
    def displayMoney(self, players):
        self.printStarline()
        print "MONEY"
        self.printLine()
        for player in players:
            print "Player", player.number, "'s money:", player.money
        self.printStarline()
    
    @controlDisplay(simulation)
    def showdown(self,pot, shared_cards, players):
        self.printStarline()
        print "TABLE"
        self.printLine()
        print "Pot:", pot 
        print "Shared cards : ", shared_cards
        for player in players:
            print "Player", player.number, "\n    cards :", player.cards, "\n    money:",player.money, "\n"
        self.pause()
        
    @controlDisplay(simulation)        
    def playAgain(self):
        while True:
            new = raw_input("Would you like to play again? (y/n) ")
            if new == 'y':
                print "Starting a new game..."
                return True
            elif new == 'n':
                self.displayer.goodbye()
                return False
            self.error("Error: Invalid choice")
    
    @controlDisplay(simulation)
    def warning(self,msg):
        print msg
     
    def error(self,msg):
        print msg 
        
    def printLine(self):
        print "---------------------------------------------------------------------" 
     
    def printStarline(self):
        print "*********************************************************************"   