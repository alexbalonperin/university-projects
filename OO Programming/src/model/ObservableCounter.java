package model;

/*Cette interface implemente le pattern observer associe au compteur de points.
L'implementation de ses fonctions permettra donc:
 	- d'ajouter (addObserver) ou de supprimer (removeObserver) des objets qui observent un compteur
 	- et de leur signaler les changements de ce dernier (notifyObserver)
*/

public interface ObservableCounter {
	
	public void addObserver(ObserverCounter obs);
	public void removeObserver();
	public void notifyObserver();
	
}
