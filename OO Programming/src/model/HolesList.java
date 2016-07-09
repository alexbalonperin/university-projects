package model;

import java.awt.geom.Point2D;
import java.awt.geom.Point2D.Double;
import java.util.ArrayList;

//Cette classe permet de particulariser la liste de trous.
//Cela signifie qu'elle ajoute des fonctionnalites qui permettent de gerer une liste de boules d'un jeu de billard.
//En particulier, elle permet d'initialiser les trous et de determiner si une boule se trouve sur l'un d'eux.

public class HolesList extends ArrayList<Hole> {

	private static final long serialVersionUID = 1L;
	
	public void initializeHoles (int nbHoles, int holesRadius)
	{
		for(int curHole = 0; curHole < nbHoles; curHole++)
		{
			int cur = curHole%2;
			Hole hole = null;
			if(curHole < 2)
				hole = new Hole(new Point2D.Double(__Pool.tablePosX, cur*(__Pool.tableHeight) + __Pool.tablePosY), holesRadius);
			else if(curHole < 4)
				hole = new Hole(new Point2D.Double(__Pool.tablePosX + __Pool.tableWidth/2, cur*(__Pool.tableHeight) + __Pool.tablePosY), holesRadius);
			else 
				hole = new Hole(new Point2D.Double(__Pool.tablePosX + __Pool.tableWidth, cur*(__Pool.tableHeight) + __Pool.tablePosY), holesRadius);
			this.add(hole);			
		}
	}
	
	public boolean ballOnHole(Ball b){
		// On teste si la boule tombe dans une poche
		boolean isOnHole = false;
		for(Hole h : this)
			// Et si c'est le cas, on la met dans la liste de boules tombée (dans l'ordre dans lequel elles tombent)
			if (h.isOnPoint(b.getPosition()))
			{
				isOnHole = true;
				Point2D.Double pos = (Double) h.getPosition().clone();
				b.setPosition(pos);
			}	
			
		return isOnHole;
	}

}
