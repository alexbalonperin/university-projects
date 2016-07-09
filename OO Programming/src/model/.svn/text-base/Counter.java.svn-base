package model;

import java.awt.Color;
import java.util.ArrayList;

//Cette classe gere l'affichage des points et des joueurs a travers un compteur qui avertit la vue lorsqu'il est modifie grace a un pattern Observer.

public class Counter implements ObservableCounter {
	
	private ArrayList<ObserverCounter> listObserver = new ArrayList<ObserverCounter>();
	private PlayerList playerList;
	private BallsList fallenBalls;
	
	public Counter(PlayerList playerList, BallsList fallenBalls) {
		this.playerList = playerList;
		this.fallenBalls = fallenBalls;
	}


	/*********************************************************************
	 * 				
	 * 					IMPLÉMENTATION PATTERN OBSERVER
	 * 
	 ***********************************************************************/

	public void addObserver(ObserverCounter obs){
		this.listObserver.add(obs);
	}
	
	@Override
	public void notifyObserver() {
		// TODO Auto-generated method stub
		
		ArrayList<Integer> points = new ArrayList<Integer>();
		ArrayList<Color> color = new ArrayList<Color>();
		
		for (int i=0; i<playerList.size(); i++)
			points.add(this.playerList.get(i).getScore());
		
		while(!fallenBalls.isEmpty()){
			color.add(fallenBalls.get(0).getColor());
			fallenBalls.remove(0);
		}
		
		for(ObserverCounter obs : listObserver)
			obs.update(playerList.getCurPlayer(), points, color);
	}
	
	@Override
	public void removeObserver() {
		// TODO Auto-generated method stub
		listObserver = new ArrayList<ObserverCounter>();
	}
	

}
