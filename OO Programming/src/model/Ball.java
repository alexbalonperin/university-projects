package model;

import java.awt.Color;
import java.awt.geom.Point2D;

//Cette classe contient els principales caracteristiques d'une boule.
//C'est elle qui s'occupe de la faire bouger en fonction de la vitesse et quand c'est demande.

public class Ball extends Shape implements Cloneable{

	private static final long serialVersionUID = 1L;

	private int radius;
	private Color color;
	private Point2D.Double posInit;
	private Point2D.Double speed = new Point2D.Double();
	
	public Ball(Point2D.Double posInit, Color color, int radius) {
		// TODO Auto-generated constructor stub
		this.color = color;
		this.radius = radius;
		this.position = posInit;
		this.posInit = new Point2D.Double(posInit.x,posInit.y);
		this.setBounds(this.position.x - radius, this.position.y - radius, 2*radius, 2*radius);	
	}
	
	public Ball(){
		
	}
		
	public void move(){
		
		int divFactor = 5;
		position.setLocation(position.x + speed.x/divFactor, position.y + speed.y/divFactor);
		
		speed.x *= 1 - Table.frotTable;
		speed.y *= 1 - Table.frotTable;
	
		this.setBounds(position.x - radius,position.y - radius, 2*radius, 2*radius);
		notifyObserverShapeBall();
	}	
	
	public boolean overLine(boolean vertical, double positionTopLeft, double positionDownRight)
	{
		if(vertical){
			return ((this.position.x+this.radius>positionDownRight && this.speed.x>0) || (this.position.x-this.radius<positionTopLeft && this.speed.x<0));
		}
		else{
			return ((this.position.y+this.radius>positionDownRight && this.speed.y>0) || (this.position.y-this.radius<positionTopLeft && this.speed.y<0));
		}
	}
	
	public boolean isMoving()
	{// Arret la balle lorsque sa vitesse est trop faible (sinon elle met trop de temps pour s'arreter)
		double norm = Math.sqrt((speed.x*speed.x) + (speed.y*speed.y));
		boolean motion = false;
		
		if(norm  <  1.0) 
			setSpeed(new Point2D.Double(0,0));
		else
			motion =  true;
		
		return motion;
	}
	
	public Ball clone() throws CloneNotSupportedException{ 
		Ball ball = null;
		try {
			ball = (Ball) super.clone();
		} catch(CloneNotSupportedException cnse) {
			cnse.printStackTrace(System.err);
		}		
		return ball; 
	} 

	
	/*********************************************************************
	 * 				
	 * 								ACCESSEURS
	 * 
	 ********************************************************************** */
	@Override
	public void setPosition(Point2D.Double p){
		this.position = p;
		this.setBounds(this.position.x - radius, this.position.y -radius, 2*radius, 2*radius);
		
		//Des que la position de la bille change, il faut le signaler a la vue
		notifyObserver();
	}

	public Point2D.Double getSpeed() {
		return this.speed;
	}

	public void setSpeed(Point2D.Double speed) {
		this.speed = speed;
	}

	public int getRadius() {
		return this.radius;
	}

	public Color getColor() {
		return this.color;
	}
	
	public Point2D.Double getPosInit() {
		return posInit;
	}
	
}
