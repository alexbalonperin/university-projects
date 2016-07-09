package model;

import java.awt.Color;
import java.awt.geom.Point2D;

//Cette classe herite de la super-classe BallsList.
//Cela est necessaire car certaine des fonctions doivent etre implementee en fonction du jeu de billard considere.
//C'est en particulier le cas de l'initialisation de la liste (creation des balles et positionnement).

public class BallsListSnooker extends BallsList {

	private static final long serialVersionUID = 1L;
	
	protected int nbRedBalls = 15;
	protected int nbColoredBalls = 6;
	
	public BallsListSnooker ()
	{
		this.ballsRadius = 10;
		this.nbrBalls = nbRedBalls + nbColoredBalls + 1;
	}

	public void initialize() // initialize la position de toutes les boules
	{		
		super.initialize();
		
		//attributs de positionnement
		int distToTable = 200;
		int diameter = 2*ballsRadius;

		//boules rouges
		for (int curBall = 0; curBall < nbRedBalls; curBall++)
		{
			Point2D.Double ballPos = null;
			if(curBall < 5)
				ballPos = new Point2D.Double(distToTable,__Pool.tablePosY + __Pool.tableHeight/2 - 2*diameter + curBall*diameter);
			else if(curBall < 9)
				ballPos = new Point2D.Double(distToTable + diameter, __Pool.tablePosY + __Pool.tableHeight/2 - 3*diameter/2 + (curBall-5)*diameter);
			else if(curBall < 12)
				ballPos = new Point2D.Double(distToTable + 2*diameter, __Pool.tablePosY + __Pool.tableHeight/2 - diameter + (curBall-9)*diameter);
			else if(curBall < 14)
				ballPos = new Point2D.Double(distToTable + 3*diameter, __Pool.tablePosY + __Pool.tableHeight/2 - diameter/2 + (curBall-12)*diameter);
			else 
				ballPos = new Point2D.Double(distToTable + 4*diameter + (curBall - 14)*diameter, __Pool.tablePosY + __Pool.tableHeight/2);
			
			Ball ball = new Ball(ballPos, Color.red, ballsRadius);
			this.add(ball);
		}
		
		//boule de couleurs
		Color couleurs[] = {Color.black, pink, Color.blue, brown, green, Color.yellow};
		double posX = 0, posY = 0;
		
		for(int curBall = 0; curBall < nbColoredBalls; curBall++){
			switch(curBall)
			{
				case 0:
					posX = distToTable/2;
					posY = __Pool.tablePosY + __Pool.tableHeight/2;
					break;
				case 1:
					posX = distToTable + 5*diameter;
					posY = __Pool.tablePosY + __Pool.tableHeight/2;
					break;
				case 2:
					posX = __Pool.tablePosX + __Pool.tableWidth/2;
					posY = __Pool.tablePosY + __Pool.tableHeight/2;
					break;
				case 3:
					posX = __Pool.tablePosX + __Pool.tableWidth - __Pool.whiteLinePos;
					posY = __Pool.tablePosY + __Pool.tableHeight/2;
					break;
				case 4:
					posX = __Pool.tablePosX + __Pool.tableWidth - __Pool.whiteLinePos;
					posY = __Pool.tablePosY + __Pool.tableHeight/2 - _Snooker.whiteCircleRadius;
					break;
				case 5:
					posX = __Pool.tablePosX + __Pool.tableWidth - __Pool.whiteLinePos;
					posY = __Pool.tablePosY + __Pool.tableHeight/2 + _Snooker.whiteCircleRadius;
					break;	
			}
			Point2D.Double ballPos = new Point2D.Double(posX,posY);
			Ball ball = new Ball(ballPos, couleurs[curBall], ballsRadius);
			this.add(ball);
		}

	}
	
	public BallsList getLastPosition(){
		//Recupere la position des boules rouges ATTENTION recupere slmt celles qui restent
		BallsList redBalls = new BallsList();
		for(Ball b: this)
		{
			if(b.getColor() == Color.red)
				redBalls.add(b);
		}
		return redBalls;
	}
	
	public boolean isRemovable(int i)
	{//Si on a affaire a une boule rouge alors elle peut etre retiree de la table
		boolean isRemovable = false;
		if (this.get(i).getColor() == Color.red)
			isRemovable = true;
		return isRemovable;
	}
	
	public int getSmallestBallValue()
	{//Retourne la plus petite valeur des boules qui restent sur la table.
		int smallestBallValue = 7;
		for (Ball b : this)
		{
			int temp = this.getBallValue(b.getColor());
			if(temp != 0 && temp < smallestBallValue)
				smallestBallValue = temp;
		}
		
		return smallestBallValue;
	}
	
	public int getBallValue (Color color) // retourne la valeur d une boule en fct de sa couleur
	{
		int value = 0;
	
		if (color == Color.red)
			value = 1;
		if (color == Color.yellow)
			value = 2;
		if (color.equals(green))
			value = 3;
		if (color.equals(brown))
			value = 4;
		if (color == Color.blue)
			value = 5;
		if (color.equals(pink))
			value = 6;
		if (color == Color.black)
			value = 7;
		
		return value;
			
	}

	/*********************************************************************
	 * 				
	 * 						  VARIABLES ACCESSOIRES
	 * 
	 ********************************************************************** */
	//ROSE
	private float r = (float) 0.8902;
	private float g = (float) 0.4196;
	private float b = (float) 0.6549;
	//VERT FONCE
	private float r1 = (float) 0.0588;
	private float g1 = (float) 0.3957;
	private float b1 = (float) 0.0588;
	//BRUN
	private float r2 = (float) 0.6353;
	private float g2 = (float) 0.3176;
	private float b2 = (float) 0.0902;

	private Color pink = new Color(r, g, b);
	private Color green = new Color(r1, g1, b1);
	private Color brown = new Color(r2, g2, b2);
}
