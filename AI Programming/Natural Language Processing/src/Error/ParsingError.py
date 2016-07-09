'''
Created on Nov 20, 2011

@author: alex
'''
class ParsingError(Exception):

    def __init__(self, message):
        """On se contente de stocker le message d'erreur"""
        self.message = message
    def __str__(self):
        """On retourne le message"""
        return self.message