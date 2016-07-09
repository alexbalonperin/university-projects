package model;

import java.awt.Point;
import java.awt.geom.Point2D;
import java.util.ArrayList;

import javax.swing.JPanel;

//Cette classe est abstraite de type forme dessinable.
//C'est-a-dire qu'elle est super-classe de toutes les formes qui seront dessinee et regroupe leur parametres et fonctions communs.
//Elle implemente le pattern Observer et permet donc de faire le lien entre les parametres des formes qui seront modifies dans le modeles et l'affichage a l'ecran (vue).

public abstract class Shape extends JPanel implements ObservableShape{
	
	private static final long serialVersionUID = 1L;
	// Origine du dessin par rapport ‡ la table.
	protected Point2D.Double position = new Point2D.Double();
	private ArrayList<ObserverShape> listObserver = new ArrayList<ObserverShape>();
	
	
	public void setPosition(Point2D.Double p){
		position = p;
		notifyObserver();
	}
	public Point2D.Double getPosition(){
		return position;
	}
	
	public boolean isOnPoint(Point2D.Double point){
		if(this.getBounds().contains(point))
			return true;
		else 
			return false;
	}
	
	public boolean isOnPoint(Point point){
		if(this.getBounds().contains(point))
			return true;
		else 
			return false;
	}
	
	public boolean isOnShape(Shape s){
		if(this.getBounds().intersects(s.getBounds()))
			return true;
		else 
			return false;
	}
	
	public void setBounds(double x, double y, int width, int height){
		setBounds((int) x, (int) y, width, height);
	}

	/*********************************************************************
	 * 				
	 * 					IMPLÉMENTATION PATTERN OBSERVER
	 * 
	 ***********************************************************************/

	public void addObserver(ObserverShape obs){
		this.listObserver.add(obs);
	}
	
	@Override
	public void notifyObserver() {
		for(ObserverShape obs : listObserver)
		{
			obs.update(this);
		}
	}
	
	@Override
	public void notifyObserverShapeBall(){
		for(ObserverShape obs : listObserver)
		{
			obs.updateShapeBall(this);
		}
	}
	
	@Override
	public void notifyObserverDrawingBall(){
		for(ObserverShape obs : listObserver)
		{
			obs.updateDrawingBall();
		}
	}

	@Override
	public void notifyObserverInit() {
		for(ObserverShape obs : listObserver)
		{
			obs.initialize(this);
		}
	}
	
	@Override
	public void removeObserver() {
		listObserver = new ArrayList<ObserverShape>();
	}
}
