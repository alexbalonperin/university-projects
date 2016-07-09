package model;

/*Cette interface implemente le pattern observer associe aux formes (queue, balles, trous,..).
L'implementation de ses fonctions permettra donc:
 	- d'ajouter (addObserver) ou de supprimer (removeObserver) des objets qui observent une forme
 	- et de leur signaler les changements de cette derniere (notifyObserver)
 	- de transmettre les parametres d'initialisation a la vue.
*/

public interface ObservableShape {

	public void addObserver(ObserverShape obs);
	public void removeObserver();
	public void notifyObserver();
	public void notifyObserverShapeBall();
	public void notifyObserverDrawingBall();
	public void notifyObserverInit();
	
}
