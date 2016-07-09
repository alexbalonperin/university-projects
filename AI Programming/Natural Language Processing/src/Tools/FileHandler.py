'''
Created on Nov 14, 2011

@author: alex
'''
import os
class FileHandler:
    
    def __init__(self):
        pass
    
    def readFile(self,path):
        f = open(path, 'r')
        data = f.read()
        f.close()
        return data
    
    def writeFile(self,path,toWrite,mode):
        f = open(path, mode)
        f.write(toWrite)
        f.close()
        
    def emptyFolder(self, folder):
        for the_file in os.listdir(folder):
            file_path = os.path.join(folder, the_file)
            try:
                os.unlink(file_path)
            except Exception, e:
                print e

    def deleteFilesExceptOne(self,filename, folder):
        fileToKeep = os.path.join(folder,filename)
        for the_file in os.listdir(folder):
            file_path = os.path.join(folder, the_file)
            try:
                if file_path != fileToKeep:
                    os.unlink(file_path)
            except Exception, e:
                print e