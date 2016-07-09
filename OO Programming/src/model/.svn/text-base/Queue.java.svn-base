package model;

//Cette classe contient les caracteristiques principales d'une queue de billard, a savoir ses dimensions, et sa position.

public class Queue extends Shape{
	
	private static final long serialVersionUID = 1L;
	private int height = 200;
	private int width = 10;
	private double angle = 0; // L'inclinaison de la queue est geree grace a un angle pour plus de souplesse.
	private int radiusWhiteBall = 0;
	private int distWhiteBall = 0; // C'est cette distance qui permet de donner l'impulsion a la boule blanche.
	
	public Queue ()
	{
		
	}
	
	public Queue(int radius) {
		this.setRadiusWhiteBall(radius);
	}
	
	
	/*********************************************************************
	 * 				
	 * 								ACCESSEURS
	 * 
	 ********************************************************************** */

	public int getWidth() {
		return width;
	}

	public void setWidth(int width) {
		this.width = width;
		notifyObserver();
	}

	public int getHeight() {
		return height;
	}

	public void setHeight(int height) {
		this.height = height;
		notifyObserver();
	}

	public double getAngle() {
		return angle;
	}

	public void setAngle(double angle) {
		this.angle = angle;
		notifyObserver();
	}


	public void setRadiusWhiteBall(int radius) {
		this.radiusWhiteBall = radius;
		notifyObserver();
	}

	public int getRadiusWhiteBall() {
		return radiusWhiteBall;
	}
	
	public void setDistWhiteBall(int distWhiteBall) {
		this.distWhiteBall = distWhiteBall;
		notifyObserver();
	}


	public int getDistWhiteBall() {
		return distWhiteBall;
	}

}
