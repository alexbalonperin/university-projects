from game.CardDeck import CardDeck
from utilities.FileHandler import FileHandler

PATH = "../../file/equiv_table10000.txt"

class WinningProbabilities:
    
    def __init__(self):
        self.file_handler = FileHandler()
    
    def getWinningProbability(self, nb_players, cards):
        table = self.file_handler.getFromFile(PATH)
        deck = CardDeck()
        for elem in table:
            if (elem[0][0][0] == cards[0][0] and elem[0][1][0] == cards[1][0]) or (elem[0][0][0] == cards[1][0] and elem[0][1][0] == cards[0][0]):
                if (deck.isSuited(elem[0]) and deck.isSuited(cards)) or (deck.isUnsuited(elem[0]) and deck.isUnsuited(cards)):
                    return elem[1][nb_players-2]
