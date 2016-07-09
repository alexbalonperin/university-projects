import java.awt.Dimension;
import java.util.ArrayList;

import model.BallsList;
import model.Counter;
import model.Hole;
import model.ObserverCounter;
import model.Queue;
import model.Table;
import model._Snooker;
import model.__Pool;

import view.BallView;
import view.HoleView;
import view.Window;

import controler.BallMouseListenerSnooker;
import controler.QueueMouseListener;

//Cette classe permet de demarrer le programme et de clairement implementer le pettern MVC en creant successivement le model, le controler et la vue.
//Elle permet egalement d'initialiser le pattern Observer en ajoutant des observer auw objets du model qui devront ensuite etre affiches par la vue.

public class Principale {
	
	public static void main(String[] args) {
		
		// Dimension de la fenetre de dialogue
		Dimension dimDialog = new Dimension(500,200);
		// Dimension totale de la fenetre bords compris. (15 en largeur et 10 en hauteur)
		Dimension dimWindow = new Dimension(980, 710);
		// Dimension du snooker dans le modele et dans la vue
		Dimension dimPool = new Dimension(965, 600);

		DialogInitPool initPool = new DialogInitPool(dimDialog);
		InfoDialogInitPool infoInitPool = initPool.getInfo();
		String names[] = {"Joueur 1","Joueur 2"};
		try{
			names[0] = infoInitPool.getNamePlayer1();
			names[1] = infoInitPool.getNamePlayer2();
		}catch(NullPointerException e){}
		
		//MODELE
		_Snooker snooker = new _Snooker(dimPool, names);
		
		//CONTROLER
		BallMouseListenerSnooker ballControler = new BallMouseListenerSnooker(snooker);
		QueueMouseListener queueControler = new QueueMouseListener(snooker, ballControler);

		//VUE
		Window window = new Window("Snooker", dimWindow, dimPool, queueControler, ballControler, snooker.getBallsList().size(), snooker.getNbHoles(), names);	
		
		//ajout des observers
		addObservers(window, snooker);
		
		//demarrage du jeu
		snooker.play();
	}
	
	private static void addObservers(Window window, __Pool pool){
		
		ArrayList<HoleView> holesView = window.getHoleViewList();
		ArrayList<BallView> ballsView = window.getBallViewList();
		
		Queue queue = pool.getQueue();
		Table table = pool.getTable();
		ArrayList<Hole> holesList = pool.getHolesList();
		BallsList ballsList = pool.getBallsList();
		Counter counter = pool.getCounter();
		
		//table
		table.addObserver(window.getTableView());
		table.notifyObserverInit();
		
		//trous
		for(int curHole = 0; curHole < holesList.size(); curHole++)
		{
			holesList.get(curHole).addObserver(holesView.get(curHole));
			holesList.get(curHole).notifyObserverInit();
		}
		
		//boules
		for(int curBall = 0; curBall < ballsList.size(); curBall++)
		{
			ballsList.get(curBall).addObserver(ballsView.get(curBall));
			ballsList.get(curBall).notifyObserverInit();
		}
		
		//queue
		queue.addObserver(window.getQueueView());
		queue.notifyObserverInit();
		
		//compteur
		counter.addObserver((ObserverCounter) window.getCounterView());
	}

}
