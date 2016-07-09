from game.Player import Player, MONEY
from game.RealPlayer import RealPlayer
from game.StupidAI import StupidAI
from game.AverageAI import AverageAI
from game.GoodAI import GoodAI
from game.ExpertAI import ExpertAI
from game.CardDeck import CardDeck
from game.Evaluator import Evaluator
from game.Displayer import Displayer
from modeler.OpponentModel import OpponentModel
from modeler.Context import Context
from utilities.FileHandler import FileHandler
from utilities.Decorators import singleton, controlPhase3
import random
import copy
import sys
import time

SMALL_BLIND = 10
BIG_BLIND = 15
NB_ITERATION = 1000
NB_ROUNDS = 4
AGGRESSIVENESS = 0.05
PATH = "../../file/context_table.txt"

@singleton
class Poker_Manager:

    phase = 3   #used to control the opponents model

    #constructor
    def __init__(self):
        self.nb_players = 0              #number of players remaining in the game
        self.nb_players_copy = 0         #number of players initially in the game
        self.players = []                #list of players remaining in the game
        self.players_copy = []           #copy of the players list to keep track of the money
        self.deck = []                   #represent the deck of cards
        self.shared_cards = []           #the cards visible to all players
        self.play = True                 #determine if a new game should be played
        self.pot = 0                     #represent the pot
        self.turn = 0                    #determine which player must play next
        self.cur_highest_bet = 0         #the highest current bet in the round
        self.winner = -1                 #number of the winner
        self.betRound = 1                #number of the round
        self.displayer = Displayer()     #object used to display msg, states of the game, etc.
        self.file_handler = FileHandler()#object used to manipulate files
        self.nb_raises = 0               #number of raises in the current round
        self.opp_model = OpponentModel(self.file_handler.getFromFile(PATH)) 
        #self.opp_model = OpponentModel() #object used to build the opponents model
        self.round_contexts = []         #actions performed by the players in the current round
    
    #allow the user to choose the number of players that will play in the next game
    def choosePlayerNb(self): 
        while True :
            try:
                self.nb_players = int(input("Choose a number of players between 2 and 10:\n"))
                if self.nb_players >= 2 and self.nb_players <= 10:
                    break     
                print "You chose a invalid number of player.\nThe number of players should be between 2 and 10."
            except NameError as error:
                self.displayer.error("Error:"+str(error))   
            except SyntaxError as error:
                self.displayer.error("Error:"+str(error)) 
        print "Number of players chosen :",self.nb_players, "\n"
        self.nb_players_copy = self.nb_players
    
    #add players in the players list according to the choice of the user
    #Players can be real or computer
    #Three different levels of computer are available
    def kindOfPlayer(self, player_nb):
        msg = "Should the player " + str(player_nb) + " be Real or a computer(Bad,Average,Good,Expert) ? (r/b/a/g/e)"
        msg2 = "    Do you want an aggressive player(bet with poorer cards) or a conservative one (bet only with good cards)?(a/c)" 
        while True:
            kind = raw_input(msg)
            if kind == 'r':
                self.players.append(RealPlayer(0))
                break
            elif kind == 'b':
                agg = raw_input(msg2)
                if agg == 'a':
                    self.players.append(StupidAI(AGGRESSIVENESS))
                    break
                elif agg == 'c':
                    self.players.append(StupidAI(0))
                    break
            elif kind == 'a':
                agg = raw_input(msg2)
                if agg == 'a':
                    self.players.append(AverageAI(AGGRESSIVENESS))
                    break
                elif agg == 'c':
                    self.players.append(AverageAI(0))
                    break
            elif kind == 'g':
                agg = raw_input(msg2)
                if agg == 'a':
                    self.players.append(GoodAI(AGGRESSIVENESS))
                    break
                elif agg == 'c':
                    self.players.append(GoodAI(0))
                    break
            elif kind == 'e':
                agg = raw_input(msg2)
                if agg == 'a':
                    self.players.append(ExpertAI(AGGRESSIVENESS))
                    break
                elif agg == 'c':
                    self.players.append(ExpertAI(0))
                    break
            self.displayer.error("Error: Invalid choice")
    
    #the players are created according to the number chosen and to the kind of players wanted        
    def createPlayers(self):
        i = 0
        self.players = []
        while i < self.nb_players :
            self.kindOfPlayer(i)
            i+=1
        self.players_copy = copy.deepcopy(self.players)

    #if a new round is played, many variables must be reinitialised 
    def initialisation(self):
        self.pot = 0
        self.shared_cards = []
        self.winner = -1
        Player.number = 0
        self.betRound = 1
        self.players = copy.deepcopy(self.players_copy)
        self.nb_players_copy = self.nb_players
        for player in self.players:
            player.init()

    #blinds are played, the players chosen to put the blinds are random
    def blinds(self):
        self.displayer.display("BLINDS")
        rand = random.randint(0,self.nb_players-1)
        self.players[rand].bet = SMALL_BLIND
        self.players[rand].money -= SMALL_BLIND
        self.players[(rand+1)%self.nb_players].bet = BIG_BLIND
        self.players[(rand+1)%self.nb_players].money -= BIG_BLIND
        self.turn = (rand + 2)%self.nb_players
        self.cur_highest_bet = BIG_BLIND
        self.displayer.showBlinds(self.players, SMALL_BLIND, BIG_BLIND, rand, self.nb_players)
        self.displayer.pause()
    
    #hole cards are dealt to all players    
    def holeCards(self):
        self.displayer.display("HOLECARDS")
        i = 0
        while i < self.nb_players :
            self.players[i].cards = self.deck.deal_n_cards(2)
            self.displayer.showPlayerCards(self.players, i)
            i+=1
        self.displayer.pause()

    #player's action is executed
    def executePlayerAction(self, cur_context):
        return self.players[self.turn].actions(self.cur_highest_bet, self.deck, self.players, cur_context, self.round_contexts)

    #if player has raised or folded, some variable must be changed
    def makeChanges(self, cur_player):
        [self.cur_highest_bet, self.nb_raises] = self.players[self.turn].hasRaised(self.cur_highest_bet, self.nb_raises)
        return self.players[self.turn].hasFolded(cur_player, self.players, self.turn)
    
    #check if there is a higher bet than the one of the current player
    def checkHigherBet(self):
        for player in self.players:
                if player.bet < self.cur_highest_bet:
                    return True
        return False
    
    #reinitialise all the variables related to the betting
    def initBetting(self):
        for player in self.players:
            player.initBetting()
        self.cur_highest_bet = 0
        self.nb_raises = 0
    
    #return the value of the pot odds 
    def calculatePotOdds(self):
        if self.pot == 0 and self.cur_highest_bet == self.players[self.turn].bet:
            return 0
        return round(float(float(self.cur_highest_bet - self.players[self.turn].bet)/float((self.cur_highest_bet - self.players[self.turn].bet) + self.pot)),3)
    
    #record the current context: number of raises, number of players left, player's action,...
    def recordContext(self, pot_odds):
        self.contexts.append(Context(self.nb_raises, pot_odds, self.nb_players, self.players[self.turn].action, self.players[self.turn].number, self.betRound, self.shared_cards)
)
    #Player turn:
    #first the state of the game is shown, then the player must choose an action
    #finally, the copy of the player list is updated and the context is recorded
    def playerTurn(self, pot_odds):
        cur_context = Context(self.nb_raises, pot_odds, self.nb_players, 'e', self.players[self.turn].number, self.betRound, self.shared_cards)
        self.players[self.turn].added = 0
        self.displayer.showSharedCards(self.shared_cards)
        self.displayer.showCurrentBet(self.cur_highest_bet)
        self.displayer.showPlayerCards(self.players, self.turn)
        self.players[self.turn].askAction()
        cur_context = Context(self.nb_raises, pot_odds, self.nb_players, self.executePlayerAction(cur_context), self.players[self.turn].number, self.betRound, self.shared_cards)
        self.round_contexts.append(cur_context)
        self.updateCopy()
        self.recordContext(pot_odds)
        self.displayer.showPlayerAction(self.players, self.turn)
    
    #each player chooses an action and the game evolves depending on this action
    def bet(self):
        self.displayer.showTable(self.pot, self.shared_cards, self.players)
        self.displayer.displayRoundNumber(self.betRound)
        higher_bet = True
        cur_player = 0
        counter = 0
        self.round_contexts = []
        while higher_bet or cur_player < len(self.players):
            if counter == self.nb_players_copy:
                self.round_contexts.pop(0)
            pot_odds = self.calculatePotOdds()
            self.playerTurn(pot_odds)
            self.pot += self.players[self.turn].added
            [cur_player, self.turn] = self.makeChanges(cur_player)
            if len(self.players) == 1:
                self.winner = self.turn
                break
            higher_bet = self.checkHigherBet() 
            counter += 1
        self.nb_players_copy = len(self.players) 
        #in case all player fold after the blind except one and the last player has put one of the blinds
        if self.betRound == 1:
            self.pot += SMALL_BLIND + BIG_BLIND
        self.betRound += 1
        self.initBetting() 

    #Add cards to the shared cards and call bet function
    def dealSharedCards(self,counter):
        self.shared_cards += self.deck.deal_n_cards(counter)
        self.bet()
     
    #Add contexts belonging to the remaining player at showdown.
    #Add their hole cards and modify the shared cards depending on the round number
    @controlPhase3(phase)
    def updateOpponentModel(self):
        remaining_contexts = []
        remaining_players = []
        for player in self.players:
            remaining_players.append(player.number)
        for context in self.contexts:
            for player in self.players: 
                if context.player_nb in remaining_players and player.number == context.player_nb:
                    context.player_cards = player.cards
                    if context.bet_round == 1:
                        context.shared_cards = []
                    else:
                        context.shared_cards = context.shared_cards[:context.bet_round+1]
                    remaining_contexts.append(context)
        self.opp_model.addContext(remaining_contexts)
    
    #main routine for a round of the game:
    #at each step, check if there is more than one player remaining in the game
    #when showdown comes, update the opponents model  
    def playRound(self):
        self.contexts = []
        self.holeCards()
        self.blinds()
        self.bet()
        if self.winner == -1:
            self.dealSharedCards(3)
            if self.winner == -1:
                self.dealSharedCards(1)
                if self.winner == -1:
                    self.dealSharedCards(1)
                    if self.winner == -1:
                        print "SHOWDOWN"
                        self.displayer.showdown(self.pot, self.shared_cards, self.players)
                        self.updateOpponentModel()
    
    #split the pot if more than one player wins the round
    def splitPot(self,maxs, winners):
        odd = self.pot%len(winners)
        if odd != 0:
                self.players[winners[0]].money += odd
        for i in range(len(maxs)):
            self.players[winners[i]].money += self.pot/len(winners)
            self.displayer.showWinner(self.players[winners[i]], self.deck.ranking(maxs[0][0]))
    
    #distribute the winnings to the players who deserve it       
    def distributeWinnings(self, maxs, winners):
        if len(maxs) > 1:   
            self.splitPot(maxs, winners)
        else:
            self.players[winners[0]].money += self.pot
            self.displayer.showWinner(self.players[winners[0]], self.deck.ranking(maxs[0][0]))        
    
    #compare the power of the remaining players and distribute the pot        
    def comparePowers(self, powers, evaluator):
        maxs = []
        max_power = powers[0]
        for i in range(len(powers)-1):
            if evaluator.card_power_greater(powers[i+1], max_power):
                max_power = powers[i+1]
        winners = []
        for i in range(len(powers)):
            if max_power == powers[i]:
                maxs.append(powers[i])
                winners.append(i)
        self.distributeWinnings(maxs, winners)
    
    #determine the winner of the round:
    #the winner calculation is different if only one person remains or more        
    def win(self):
        evaluator = Evaluator()
        powers = []
        if self.winner != -1: #everyone folded exept one guy
            self.players[self.winner].money += self.pot
            self.displayer.debugRanking(self.players, self.winner, self.shared_cards)
            powers = evaluator.calc_cards_power(self.players[self.winner].cards+self.shared_cards, len(self.shared_cards)+2)
            self.displayer.showdown(self.pot, self.shared_cards, self.players)
            self.displayer.showWinner(self.players[self.winner], self.deck.ranking(powers[0]))
        else: 
            for player in self.players:
                powers.append(evaluator.calc_cards_power(player.cards+self.shared_cards, len(self.shared_cards)+2))
            self.comparePowers(powers, evaluator)
        
    #update the copy of the player list to keep track of the money earned during several games                  
    def updateCopy(self):
        for player in self.players:
            for player_copy in self.players_copy:
                if player.number == player_copy.number:
                    player_copy.money = player.money
                    
    #sum the money of all the player remaining in the game                
    def sumMoney(self, players):
        sum_money = 0
        for player in players:
            sum_money += player.money 
        return sum_money
    
    #check if the total amount of money in the game has not changed  
    def checkMoney(self):
        try:
            sum_money = int(self.sumMoney(self.players_copy))
            assert MONEY*self.nb_players == sum_money
        except AssertionError:
            self.displayer.error("Error: Money sum ("+str(sum_money)+") is incorrect. It should be ("+str(MONEY*self.nb_players)+")\n\n*************STOPPING PROGRAM**************")
            sys.exit(0)
            
    #main routine of the game:
    #welcome screen, developpement of the game and goodbye screen are done here  
    def game(self):
        self.displayer.welcome()
        self.choosePlayerNb() 
        self.createPlayers()
        time_before = time.time()
        iteration = 0
        #while loop condition depending on the purpose: playing or simulating
        while self.play or iteration < NB_ITERATION:
            print "iteration = ", iteration
            self.deck = CardDeck()
            self.playRound()
            self.win()
            self.updateCopy()
            self.checkMoney()
            self.play = self.displayer.playAgain()
            self.initialisation()
            iteration += 1
        self.displayer.displayMoney(self.players_copy)
        time_after = time.time()
        print time_after - time_before
        self.displayer.goodbye()
        #self.opp_model.recordContextTable()

     
              
