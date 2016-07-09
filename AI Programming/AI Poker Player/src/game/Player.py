from game.Evaluator import Evaluator
from game.Displayer import Displayer

MAX_NUMBER_BET = 3
MONEY = 5000
RAISE = 10

class Player:
    
    number = 0      #static variable
    
    #constructor
    def __init__(self, aggressiveness):
        self.money = MONEY                  #amount of money available to the player
        self.name = " "                     #name of the player (FOR FUTUR USE) 
        self.bet = 0                        #amount bet so far in the current round
        self.action = 'e'                   #action chosen
        self.number = Player.number         #player's number
        Player.number += 1              
        self.nb_bet = 0                     #number of bet so far --> allow to limit the number of bet in a round
        self.evaluator = Evaluator()        #object used to evaluate the power of a hand
        self.displayer = Displayer()        #object used to display msg, game state, etc.
        self.added = 0                      #amount added to the player's bet to match the current bet or to raise the current bet
        self.aggressiveness = aggressiveness#determine the aggressiveness of the player
        #if self.aggressiveness > 0:
        #    RAISE = 50
    
    #reinitialise the betting variables after each round
    def initBetting(self):
        self.bet = 0
        self.nb_bet = 0
    
    #reinitialise the cards and betting after each game    
    def init(self):
        self.cards = []
        self.initBetting()
    
    #if the player has raised, the bet and number of raises must be updated
    def hasRaised(self, cur_bet, nb_raises):
        if self.action == 'r': 
            return self.bet, nb_raises+1
        else: 
            return cur_bet, nb_raises
     
    #if the player has folded, the list of players, the cur_player and the turn must be updated  
    def hasFolded(self, cur_player, players, turn):
        if self.action != 'f': 
            return cur_player + 1, (turn + 1)%len(players)
        else:
            players.pop(turn) 
            return cur_player, (turn)%len(players)       
    
    #each type of player/computer chooses the action differently    
    def actions(self, currentBet, deck, players, context, roundActions):
        raise NotImplementedError("Subclass must implement abstract method")
    
    #only used by real players but allow polymorphism     
    def askAction(self):
        raise NotImplementedError("Subclass must implement abstract method")
    
    #call the current bet
    def call(self, currentBet):
        self.added = currentBet - self.bet
        self.bet += self.added
        self.money -= self.added
        self.displayer.showPlayerMoney(self.number, self.money)

    #fold
    def fold(self):
        self.displayer.showPlayerMoney(self.number, self.money)

    #raise the current bet if it is still possible
    def betting(self,currentBet):
        if self.nb_bet <= MAX_NUMBER_BET:
            toAdd = currentBet - self.bet
            self.added = toAdd + RAISE
            self.bet += self.added
            self.money -= self.added
            self.nb_bet += 1
        else:
            self.displayer.warning("*********Maximum number of raises attained***********") 
            self.call(currentBet)
            self.action = 'c'
        self.displayer.showPlayerMoney(self.number, self.money)
            
    ##############################
    #
    #       ACCESSORS
    #
    ##############################

    def _get_money(self):
        return self._money

    def _set_money(self,new_money):
        self._money = new_money

    def _get_bet(self):
        return self._bet

    def _set_bet(self,new_bet):
        self._bet = new_bet

    def _get_cards(self):
        return self._cards

    def _set_cards(self,new_cards):
        self._cards = new_cards

    def _get_action(self):
        return self._action

    def _set_action(self,new_action):
        self._action = new_action

    def _get_betRaise(self):
        return self._betRaise

    def _get_added(self):
        return self.added

    money = property(_get_money,_set_money)
    bet = property(_get_bet, _set_bet)
    cards = property(_get_cards, _set_cards)
    action = property(_get_action, _set_action)
    betRaise = property(_get_betRaise)
    added = property(_get_added)
    
