package view;

import java.awt.Color;
import java.awt.Graphics;

import model.Hole;
import model.Shape;

//Cette classe represente la partie graphique d'un trou.
//Elle permet donc de dessiner un trou en fonction de ses caracteristiques (dimension et position).

public class HoleView extends ShapeView {
	
	private int radius;
	
	public HoleView(Drawing drawing) {
		// TODO Auto-generated constructor stub
		this.drawing = drawing;
	}

	public void initialize(Shape s){
		Hole hole = (Hole)s;
		this.position = s.getPosition();
		this.radius = hole.getRadius();
		drawing.repaint();
	}
	
	@Override
	public void paintComponent(Graphics g) {
		// TODO Auto-generated method stub
		g.setColor(Color.BLACK);
		g.fillOval((int) (position.x - radius), (int) (position.y - radius), 2*radius, 2*radius);// Attention : on renvoit la forme, pas la position.
		// Remarque : le trou n'est encore qu'un simple rond noir, on peut ajouter une "rigole" devant.

	}

}

