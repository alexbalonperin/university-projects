package model;

import java.awt.Dimension;
import java.awt.geom.Point2D;

//Cette classe regroupe les caracteristiques de la table de jeu et permet de faire rebondir une boule dessus (bounceWithTable).

public class Table extends Shape{

	
	private static final long serialVersionUID = 1L;
	
	static double frotTable = 0.005; // facteur de décroissance de la vitesse avec le temps.
	private Dimension dimension;
	
	// On crée la table en lui passant en vrac des boules et des trous.
	public Table(Dimension dim, HolesList holes, Point2D.Double position) 
	{
		dimension = dim;
		this.position = position;
	}
	
	public void bounceWithTable(Ball b){
		//Modifie la vitesse de la boule b en fonction d'un eventuel rebond avec la table.
		Point2D.Double previousSpeed = new Point2D.Double (b.getSpeed().x, b.getSpeed().y);

		if(b.overLine(true, position.x, position.x + dimension.width))
				b.setSpeed(new Point2D.Double( -previousSpeed.x, previousSpeed.y));

		else if(b.overLine(false, position.y, position.y + dimension.height))
				b.setSpeed(new Point2D.Double( previousSpeed.x, -previousSpeed.y));
	}
	
	/*********************************************************************
	 * 				
	 * 								ACCESSEURS
	 * 
	 ********************************************************************** */

	public Dimension getDimension() {
		return dimension;
	}

	public double getFrotTable() {
		return frotTable;
	}
}
