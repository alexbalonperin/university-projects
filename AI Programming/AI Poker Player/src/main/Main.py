# -*-coding:Latin-1 -*
from game.Poker_Manager import Poker_Manager
from simulation.RollOutSimulation import RollOut

if __name__ == "__main__":
    simulation = RollOut()
    simulation.simulation()
    poker = Poker_Manager()
    poker.game()