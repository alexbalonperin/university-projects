package view;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.geom.Point2D;

import model.Ball;
import model.Shape;

//Cette classe represente la partie graphique d'une boule.
//Elle permet donc de dessiner une boule en fonction de ses caracteristiques (dimension et position).

public class BallView extends ShapeView{

	private int radius;
	private Color color;
	private Point2D.Double posInit;
	
	public BallView(Drawing drawing) {
		this.drawing = drawing;
	}
	
	public void initialize(Shape s){
		Ball ball = (Ball)s;
		this.position = s.getPosition();
		this.color = ball.getColor();
		this.radius = ball.getRadius();
		this.posInit = ball.getPosInit();
		drawing.repaint();
	}
	
	@Override
	public void paintComponent(Graphics g) {
		g.setColor(this.color);
		g.fillOval((int) (position.x - radius) ,(int) (position.y - radius), 2*radius, 2*radius);

		/*int radiusMouche = 3;
		if(!g.getColor().equals(Color.red) && !g.getColor().equals(Color.white))
			g.fillOval((int) (posInit.x - radiusMouche) ,(int) (posInit.y - radiusMouche), 2*radiusMouche, 2*radiusMouche);*/
	}

	
}
