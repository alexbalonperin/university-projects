package model;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.geom.Point2D;
import java.awt.geom.Point2D.Double;
import java.util.ArrayList;

//Cette classe contient les regles qui sont specifiques au Snooker.
//Principalement: le replacement des boules de couleur ainsi que le calcul du score.

public class _Snooker extends __Pool{
	
	static int whiteCircleRadius = 80;
	BallsList redBalls;
	ArrayList<Integer> lostPoints = null;
	
	public _Snooker(Dimension dimSnooker, String names[]){
		this.dimGame = dimSnooker;
		this.holesRadius = 30;
		this.nbHoles = 6;
		this.dimTable = new Dimension(this.dimGame.width - 60, this.dimGame.height - 85);
		initializeModel(names);
	}

	protected void initializeModel(String names[])
	{				
		super.initializeModel(names);
		
		ballsList = new BallsListSnooker();
		
		ballsList.initialize();

		super.initializeModel2();

	}
	
	
	protected void ballReplacement(){
		super.ballReplacement();
		
		for(Ball b : lostBalls)
		{
			if(!b.getColor().equals(Color.red)){ //Si ce n'est pas une boule rouge alors il faut la replacer

				Point2D.Double pos = (Double) b.getPosInit().clone();
				if(!b.getColor().equals(Color.WHITE)) // on a deja replace la blanche donc maintenant on replace les boules de couleur non rouge
				{
					if(!redBalls.isEmpty() || nextPlayer) // Attention, lorsqu'il n'y a plus de boule rouge sur la table alors il ne faut plus necessairement replacer les boules de couleur (voir les regles du snooker)
					{
						int counter = 0;
						boolean firstTime = true;
						for(int i = 0 ; i < ballsList.size() && counter < posInit.size(); i++)
						{
							b.setPosition(pos);	
					
							if(ballsList.get(i).isOnShape(b) && !ballsList.get(i).equals(b)) // on ne veut pas qu'une boule se replace sur une autre
							{
								if(firstTime && !b.getColor().equals(Color.BLACK))
								{
									counter = 0;
									firstTime = false;
								}
								else
									counter++;
								
								if(counter < posInit.size())
									pos = (Double) posInit.get(counter).clone();
								else
								{
									counter = 0;
									pos = (Double) b.getPosInit().clone();
									pos.x += 2*b.getRadius();
								}
								i = -1;
							}
						}
						b.setPosition(pos);
					}
					else
						ballsList.remove(b);
				}
			}
		}
		try{
			Thread.sleep(100);
		}catch(InterruptedException e) {}
		
	}
	
	void round(int player) {
		//recupere les positions des boules rouges avant chaque tour (les vraies regles du snooker permettent au jouer de parfois choisir de replacer les boules rouges donc ca pourrait etre utile.
		redBalls = ((BallsListSnooker) ballsList).getLastPosition();
		
		// routine générale d'un billard
		super.round(player);
		
		if(!nextPlayer)
			for(Ball b : lostBalls)
				if(!b.getColor().equals(Color.white))
					fallenBalls.add(b);
	}

	
	@Override
	public void modifyScore(int changeScore) {
		int curPlayer = playerList.getCurPlayer();
		if (changeScore > 0)
		{
			playerList.get(curPlayer).setLastColorTouched(ballsList.getColorFirstBallTouched()); // servira pour le coup suivant du meme tour
			playerList.get(curPlayer).modifieScore(changeScore);
			nextPlayer = false;
		}
		
		else // le score est nul ou plus petit que 0
		{
			nextPlayer = true;
			playerList.get(curPlayer).setLastColorTouched(null); // on reinitialise la suite de boules touchees du tour
			if (changeScore < 0) // le coup n'etait donc pas valide, il faut remettre sur la table les boules tombees dans les trous A FAIRE
			{
				playerList.get((curPlayer+1) % nbrPlayer).modifieScore(-changeScore);
			}
		}

		ballsList.setColorFirstBallTouched(null);	
	}
	

	@Override
	int scoreMgmt(int player) {
		int wonPoints = 0;
		lostPoints = new ArrayList<Integer>(); // on enregistre les fautes pour apres comptabiliser la plus grosse
		if (playerList.get(player).getLastColorTouched() == null || playerList.get(player).getLastColorTouched() != Color.red) // si c est le premier coup du tour ou si la derniere etait pas une rouge
		{
			if(ballsList.getColorFirstBallTouched() == null)
				lostPoints.add(4);
			else if (ballsList.getColorFirstBallTouched() != Color.red) // si on ne touche pas une rouge en premier alors l adversaire gagne le nombre de points de la boule touchee et le coup est non valide
			{
				lostPoints.add(((BallsListSnooker) ballsList).getBallValue(ballsList.getColorFirstBallTouched()));
				lostPoints.add(4);
			}
			wonPoints += checkBallIn();		
		}	
		else
		{
			if (ballsList.getColorFirstBallTouched() == null || ballsList.getColorFirstBallTouched() == Color.red)
				lostPoints.add(4);
			if (redBalls.isEmpty()) //si il n y a plus de rouges sur la table alors on doit toucher la boule de valeur la plus faible
			{
				if(((BallsListSnooker) ballsList).getBallValue(ballsList.getColorFirstBallTouched()) != ((BallsListSnooker) ballsList).getSmallestBallValue())
				{
					lostPoints.add(((BallsListSnooker) ballsList).getBallValue(ballsList.getColorFirstBallTouched()));
					lostPoints.add(4);
				}
				else
					wonPoints += checkBallIn();
			}
			else // il reste des rouges sur la table
				//on ne peut mettre que la boule touchee en premier dans un trou et ca peut pas etre une rouge
				wonPoints += checkBallIn();
			
		}
		
		if (!lostPoints.isEmpty())//le coup n'etait pas valide donc on va voir quelle faute vaut le maximum de points
		{
			int maxFault = 4;
			for (Integer p : lostPoints)
				if (p > maxFault)
					maxFault = p;
			wonPoints = -maxFault;
		}
		
		return wonPoints;
	}
	
	private int checkBallIn() // verifie si la boule tombee dans le trou est correcte et modifie les points gagnes ou perdus en consequence.
	{
		int wonPoints = 0;
		for (Ball b : lostBalls) // on parcourt les boules tombees
		{
			if (b.getColor() == ballsList.getColorFirstBallTouched())
				wonPoints += ((BallsListSnooker) ballsList).getBallValue(b.getColor());
			else
			{
				if(b.getColor() == Color.white) // si la blanche est empochee alors le coup et non valide et 4 points supp pour l adversaire)
					lostPoints.add(4);
				else // si une autre boule tombe ladversaire gagne le nombre de points de la boule.
				{
					lostPoints.add(((BallsListSnooker) ballsList).getBallValue (b.getColor()));	
					lostPoints.add(4);
				}
			}
		}
		
		return wonPoints;
	}
	
}
