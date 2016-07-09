import math

"""
    this class defines the context of the game and is used to build the opponents model
"""
class Context:
    
    def __init__(self, nb_raises, pot_odds, nb_players, player_action, player_nb, bet_round, shared_cards):
        self.nb_raises = nb_raises
        self.pot_odds = pot_odds
        self.nb_players = nb_players
        self.player_action = player_action
        self.shared_cards = shared_cards
        self.player_nb = player_nb
        self.bet_round = bet_round
        self.player_cards = []

    def printContext(self):
        print 
        print "CONTEXT: Player ",self.player_nb,"\n    cards:",self.player_cards,"\n    action:",self.player_action,"\n    nb raises:",self.nb_raises,
        print "\n    bet round:",self.bet_round,"\n    shared cards:",self.shared_cards,"\n    nb players:",self.nb_players,"\n    pot odds:",self.pot_odds,"\n"

    #check if the current context is equal to context
    def equal(self, context):
        return self.player_action == context.player_action and self.nb_raises == context.nb_raises and self.bet_round == context.bet_round  and self.player_nb == context.player_nb and math.fabs(self.pot_odds - context.pot_odds) <= 0.05 
    
    
    ##############################
    #
    #       ACCESSORS
    #
    ##############################

    def _get_nb_raises(self):
        return self._nb_raises

    def _set_nb_raises(self,new_nb_raises):
        self._nb_raises = new_nb_raises

    def _get_pot_odds(self):
        return self._pot_odds

    def _set_pot_odds(self,new_pot_odds):
        self._pot_odds = new_pot_odds

    def _get_nb_players(self):
        return self._nb_players
    
    def _set_nb_players(self,new_nb_players):
        self._nb_players = new_nb_players

    def _get_player_action(self):
        return self._player_action
    
    def _set_player_action(self,new_player_action):
        self._player_action = new_player_action
    
    def _get_shared_cards(self):
        return self._shared_cards
    
    def _set_shared_cards(self,new_shared_cards):
        self._shared_cards = new_shared_cards

    def _get_player_nb(self):
        return self._player_nb
    
    def _set_player_nb(self,new_player_nb):
        self._player_nb = new_player_nb
        
    def _get_bet_round(self):
        return self._bet_round
    
    def _set_bet_round(self,new_bet_round):
        self._bet_round = new_bet_round

    def _get_player_cards(self):
        return self._player_cards
    
    def _set_player_cards(self,new_player_cards):
        self._player_cards = new_player_cards

    nb_raises = property(_get_nb_raises,_set_nb_raises)
    pot_odds = property(_get_pot_odds,_set_pot_odds)
    nb_players = property(_get_nb_players,_set_nb_players)
    player_action = property(_get_player_action,_set_player_action)
    shared_cards = property(_get_shared_cards, _set_shared_cards)
    player_nb = property(_get_player_nb, _set_player_nb)
    bet_round = property(_get_bet_round, _set_bet_round)
    player_cards = property(_get_player_cards, _set_player_cards)