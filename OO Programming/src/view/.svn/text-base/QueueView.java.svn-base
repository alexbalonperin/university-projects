package view;

import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.geom.AffineTransform;
import java.awt.image.ImageObserver;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;

import model.Queue;
import model.Shape;

//Cette classe represente la partie graphique d'une queue.
//Elle permet donc de dessiner une queue en fonction de ses caracteristiques (dimension et position).

public class QueueView extends ShapeView implements ImageObserver{
	
	private int width;
	
	private double angle = 0;
	private int distWhiteBall = 0;
	private int radiusWhiteBall;
	
	
	public QueueView(Drawing drawing) {
		this.drawing = drawing;
	}
	
	public void update(Shape s){
		
		Queue queue = (Queue) s;
		this.angle = queue.getAngle();
		this.distWhiteBall = queue.getDistWhiteBall(); 
		this.position.x = queue.getPosition().x;
		this.position.y = queue.getPosition().y;
		
		drawing.repaint();
	}
	
	public void initialize(Shape s){
		Queue queue = (Queue) s;
		this.width = queue.getWidth();
		this.radiusWhiteBall = queue.getRadiusWhiteBall();
		this.angle = queue.getAngle();
		this.distWhiteBall = queue.getDistWhiteBall(); 
		this.position.x = s.getPosition().x;
		this.position.y = s.getPosition().y;
		
		drawing.repaint();
	}
	
	@Override
	public void paintComponent(Graphics g) {
		int distEffective = distWhiteBall*2; //Pour augmenter le recul de la queue.
		Graphics2D g2 =(Graphics2D) g;
	    AffineTransform at = new AffineTransform();
	    
	    at.translate(position.x + (int)((distEffective + radiusWhiteBall/2)* Math.cos(angle)) , position.y + (int)((distEffective + radiusWhiteBall/2)* Math.sin(angle)));
	    at.rotate(angle - Math.PI/2);
	    at.translate(-width/2-6, -width/2+radiusWhiteBall);
		  
		try {
			Image img = ImageIO.read(new File("Images/queue.png"));

		    g2.drawImage(img,at,this); 
		} 
		catch (IOException e) {
		// todo auto-generated catch block
			e.printStackTrace();
		}
		
	}

	@Override
	public boolean imageUpdate(Image img, int infoflags, int x, int y,
			int width, int height) {
		// TODO Auto-generated method stub
		return false;
	}


}
