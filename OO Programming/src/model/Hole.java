package model;

import java.awt.geom.Point2D;

//Cette classe contient les caracteristiques principales d'un trou, a savoir son rayon et donc ses limites.

public class Hole extends Shape{

	private static final long serialVersionUID = 1L;
	private int radius;
	
	public Hole(Point2D.Double position, int radius) {
		// TODO Auto-generated constructor stub
		this.position = position;// /!\ position doit être le coin sup gauche.
		this.setRadius(radius);
		this.setBounds(this.position.x - radius, this.position.y -radius, 2*radius, 2*radius);
	}

	/*********************************************************************
	 * 				
	 * 								ACCESSEURS
	 * 
	 ********************************************************************** */
	
	public void setRadius(int radius) {
		this.radius = radius;
	}

	public int getRadius() {
		return radius;
	}
}
