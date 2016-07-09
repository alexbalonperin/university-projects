# -*-coding:Latin-1 -*
def singleton(classe_definie):
    instances = {} 
    def get_instance():
        if classe_definie not in instances:
            instances[classe_definie] = classe_definie()
        return instances[classe_definie]
    return get_instance

def controlDisplay(simulation):  
    def decorator(function):
        def new_function(*parametres_non_nommes, **parametres_nommes):
            if not(simulation):
                function(*parametres_non_nommes, **parametres_nommes)
        return new_function
    return decorator

def controlSimulation(isSimuling):
    def decorator(function):
        def new_function(*parametres_non_nommes, **parametres_nommes):
            if isSimuling:
                function(*parametres_non_nommes, **parametres_nommes)
        return new_function
    return decorator

def controlPhase3(phase):
    def decorator(function):
        def new_function(*parametres_non_nommes, **parametres_nommes):
            if phase == 3:
                function(*parametres_non_nommes, **parametres_nommes)
        return new_function
    return decorator

def debugging(debug):  
    def decorator(function):
        def new_function(*parametres_non_nommes, **parametres_nommes):
            if debug:
                function(*parametres_non_nommes, **parametres_nommes)
        return new_function
    return decorator