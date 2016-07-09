package view;

import java.awt.Graphics;
import java.awt.geom.Point2D;

import model.ObserverShape;
import model.Shape;

//Cette super-classe regroupe les objets graphiques qui servent a dessiner des "Shapes".
//Elle implemente egalement le pattern Observer pour pouvoir actualiser les dessins.

public abstract class ShapeView implements ObserverShape{
	// Origine du dessin par rapport à la table.
	protected Point2D.Double position = new Point2D.Double();
	protected Drawing drawing;
	
	public Point2D.Double getPosition(){
		return position;
	}
	
	// Dessine la forme sur un objet graphic.
	public abstract void paintComponent(Graphics g);

	@Override
	public void update(Shape s) {
		this.position = s.getPosition();
		drawing.repaint();
	}

	@Override
	public void updateShapeBall(Shape s) {
		this.position = s.getPosition();
	}
	
	@Override
	public void updateDrawingBall() {
		drawing.repaint();
	}
	
	public void initialize(Shape s){
		this.position = s.getPosition();
		drawing.repaint();
	}
}
