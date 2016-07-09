from game.Evaluator import Evaluator
from utilities.FileHandler import FileHandler
from strength.WinningProbabilities import WinningProbabilities

PATH = "../../file/context_table.txt"

class OpponentModel:
    
    def __init__(self, context_table = []):
        self.evaluator = Evaluator()
        self.winning_prob = WinningProbabilities()
        self.file_handler = FileHandler()
        self.context_table = context_table
    
    def recordContextTable(self):
        self.file_handler.dumpToFile(self.context_table, PATH) 
    
    #return the estimated strength of the cards in the current context
    def getEstimatedStrength(self, context):
        for i in range(len(self.context_table)):
            if self.context_table[i][0].equal(context):
                return self.context_table[i][1]
        return -1
    
    def printContextTable(self):
        print "CONTEXT TABLE:"
        for i in range(len(self.context_table)):
            self.context_table[i][0].printContext()
            print "    estimated hand strength = ", self.context_table[i][1]
    
    #add new contexts to the table or update the table if necessary    
    def addContext(self, contexts):
        #self.printContextTable()
        for context in contexts:
            #context.printContext()
            [inTable, indice, estimated_strength] = self.inTable(context)
            if inTable:
                #print "update"
                self.updateTable(context, indice, estimated_strength)
            else:
                #print "adding contexts"
                strength = self.winning_prob.getWinningProbability(context.nb_players, context.player_cards)
                self.context_table.append([context,strength])
    
    #calculate the winning probability of the cards from the current context 
    #and average it with the existing one    
    def updateTable(self, cur_context, indice, estimated_strength):
        cur_strength = self.winning_prob.getWinningProbability(cur_context.nb_players, cur_context.player_cards)
        avg_strength = round(float(cur_strength + estimated_strength)/2.0,3)
        self.context_table[indice][1] = avg_strength
    
    #check if the context is already in the table and if it is return the indice in the table 
    #and the value of the estimated strength so far 
    def inTable(self, cur_context):
        for i in range(len(self.context_table)):
            if cur_context.equal(self.context_table[i][0]):
                return True, i, self.context_table[i][1]
        return False, -1, -1
    
    