package model;

import java.awt.Color;
import java.awt.geom.Point2D;
import java.util.ArrayList;

//Cette classe permet de particulariser la liste de balles.
//Cela signifie qu'elle ajoute des fonctionnalites qui permettent de gerer une liste de boules d'un jeu de billard.
//En particulier, elle va creer les boules (en les positionnant) et gerer leurs rebonds entre elles.

public class BallsList extends ArrayList<Ball>{

	private static final long serialVersionUID = 1L;
	
	protected int ballsRadius;
	protected int nbrBalls;
	protected Ball whiteBall = new Ball();
	protected Color colorFirstBallTouched = null;
	
	public void initialize(){
		
		//boule blanche
		double posX = __Pool.tablePosX + __Pool.tableWidth - __Pool.whiteLinePos;
		double posY = __Pool.tablePosY + __Pool.tableHeight/2 + 2*ballsRadius;
		
		Point2D.Double pos = new Point2D.Double(posX,posY);
		whiteBall = new Ball(pos, Color.WHITE, ballsRadius);
		
		//ajoute la boule blanche
		this.add(whiteBall);

	}
	
	public boolean add(Ball b){
		super.add(b);
		return true;
	}

	public void bounce(Ball a, Ball b){
		//Modifie les vitesses de deux boules a et b qui se collisionnent
		
		double posAPRBX = a.getPosition().x - b.getPosition().x; // Position relative de A par rapport  B selon x.
		double posAPRBY = a.getPosition().y - b.getPosition().y; // Position relative de A par rapport  B selon y.
		double inclinaisonAB = 0;
		try{
			inclinaisonAB = Math.atan(posAPRBY/posAPRBX);
		}
		catch (ArithmeticException e) {
			inclinaisonAB =  Math.PI/2;
		}
		inclinaisonAB = Math.abs(inclinaisonAB);
		
		double speedAParaAB = (Math.abs(a.getSpeed().x * Math.cos(inclinaisonAB))) + Math.abs((a.getSpeed().y * Math.sin(inclinaisonAB)));
		double speedBParaAB = (Math.abs(b.getSpeed().x * Math.cos(inclinaisonAB))) + Math.abs((b.getSpeed().y * Math.sin(inclinaisonAB)));

		if((speedAParaAB-speedBParaAB)>0){
				
			Point2D.Double newSpeedAParaAB = new Point2D.Double ((int) (Math.signum(b.getSpeed().x) * speedBParaAB * Math.cos(inclinaisonAB)), (int) (Math.signum(b.getSpeed().y) * speedBParaAB * Math.sin(inclinaisonAB)));
			Point2D.Double newSpeedBParaAB = new Point2D.Double ((int) (Math.signum(a.getSpeed().x) * speedAParaAB * Math.cos(inclinaisonAB)), (int) (Math.signum(a.getSpeed().y) * speedAParaAB * Math.sin(inclinaisonAB)));
		 
			Point2D.Double speedALeft = new Point2D.Double ( a.getSpeed().x - newSpeedBParaAB.x, a.getSpeed().y - newSpeedBParaAB.y); // chaque boule a perdu la vitesse transmis a l'autre
			Point2D.Double speedBLeft = new Point2D.Double ( b.getSpeed().x - newSpeedAParaAB.x, b.getSpeed().y - newSpeedAParaAB.y);
		 
			Point2D.Double finalSpeedA = new Point2D.Double ( speedALeft.x + newSpeedAParaAB.x, speedALeft.y + newSpeedAParaAB.y);
			Point2D.Double finalSpeedB = new Point2D.Double ( speedBLeft.x + newSpeedBParaAB.x, speedBLeft.y + newSpeedBParaAB.y);
		 
			a.setSpeed(finalSpeedA);
			b.setSpeed(finalSpeedB);
		}
	}
	
	public void collisions (Ball b)
	{	//Verifie tous les rebonds que la boule b va engendrer
		//Cette fonction est recursive car quand une boule a collisionne une boule b (et donc change sa vitesse), il faudra alors reverifier tous les rebonds que la boule b pourrait engendrer avec cette nouvelle vitesse.
		if (b.isMoving()){
			try {
				//pour éviter les chevauchements on cree une copie de la boule
				Ball copyBall = b.clone();
				copyBall.move();
				// On fait rebondir les boules
				for(Ball c : this){
					// test si une boule possede une intersection avec une autre (attention a ne pas tester entre une boule et elle meme)
					if (copyBall.isOnShape(c) && b!=c)
					{
						// on récupère la couleur de la première balle touchée et on s'assure d'en avoir touchee une
						if (colorFirstBallTouched == null && (b.getColor() == Color.white || c.getColor() == Color.white)){
							if (b.getColor() == Color.white)
								colorFirstBallTouched = c.getColor();
							else
								colorFirstBallTouched = b.getColor();
						}
						this.bounce(b,c);
						collisions (c);
					}
				}
			} catch (CloneNotSupportedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}	
	}
	
	public Ball getWhiteBall()
	{
		Ball whiteBall = null;
		try{
			for (Ball c : this)
				if (c.getColor() == Color.white)
					whiteBall = c;
		}
		catch (NullPointerException e)
		{
		}
		
		return whiteBall;			
	}
	
	public boolean isRemovable(int i)
	{
		return true;
	}
	
	public void move(){
		//Fais bouger toutes les boules de la liste.
		for(Ball b : this){
			b.move();
		}
		try{
			this.get(0).notifyObserverDrawingBall();
		}
		catch(IndexOutOfBoundsException e){}
	}
	
	public int getBallsRadius()
	{
		return ballsRadius;
	}
	
	public Color getColorFirstBallTouched()
	{
		return colorFirstBallTouched;
	}
	
	public void setColorFirstBallTouched(Color colorFirstBallTouched)
	{
		this.colorFirstBallTouched = colorFirstBallTouched;
	}
}
