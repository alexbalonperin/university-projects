package model;

import java.util.ArrayList;

//Cette classe s'occupe de gerer le deplacement des billes (par l'intermediaire d'un thread) ainsi que leurs rebonds durant tout un tour (entre le moment ou elles demarrent et ou elles s'arretent).

public class RoundGestion extends Thread  {

	private BallsList ballsList;
	private HolesList holesList;
	private ArrayList<Ball> lostBalls;
	private Table table;
	private int waitTime = 20;
	

	public RoundGestion(__Pool pool){
		this.ballsList = pool.getBallsList();
		this.holesList = pool.getHolesList();
		this.lostBalls = pool.getLostBalls();
		this.table = pool.getTable();
	}
	
	public void run(){
		boolean playing = false;
		do{
			playing = false;
			// verifie s'il y a des rebonds et recupere les boules tombees dans les trous 
			bounces();
			// On teste si il y a encore des boules ayant une vitesse non nulle.
			for (Ball b : ballsList){
				if (b.isMoving()){
					playing = true;
					break;
				}
			}
			try{
				Thread.sleep(waitTime);
			}catch(InterruptedException e) {}
		}
		while (playing);		
		
	}
	
	public void bounces(){
		ballsList.move();
		for(Ball b : ballsList)
		{
			//collisions avec la table
			table.bounceWithTable(b);
			//collisions entre boules
			ballsList.collisions (b);
			
		}
		//Verifie si des boules sont dans un des trous
		for(int i = 0; i < ballsList.size() ; i++)
			if(holesList.ballOnHole(ballsList.get(i)))
			{
				if(!lostBalls.contains(ballsList.get(i))){
					lostBalls.add(ballsList.get(i));
					// Et si elles peuvent etre retirees de la tables, on les retire de la liste de boule de la table.
					if (ballsList.isRemovable(i))
						ballsList.remove(ballsList.get(i));
				}
			}
	}
	
}
