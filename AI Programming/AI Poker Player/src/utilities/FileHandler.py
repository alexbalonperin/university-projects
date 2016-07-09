import pickle

class FileHandler:
    
    #copy an object to a file defined in path
    def dumpToFile(self, obj, path):
        with open(path, "wb") as my_file:
            pickler = pickle.Pickler(my_file)
            pickler.dump(obj)
    
    #get an object from a file and return it       
    def getFromFile(self, path):
        with open(path, "rb") as my_file:
            depickler = pickle.Unpickler(my_file)
            return depickler.load()