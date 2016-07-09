package view;

import java.awt.Graphics;
import java.util.ArrayList;
import java.util.Iterator;
import javax.swing.JPanel;


public class Drawing extends JPanel implements Iterable<ShapeView>{
	
	private static final long serialVersionUID = 1L;
	
		ArrayList<ShapeView> shapes;
		
		public Drawing(){
			super();
			shapes = new ArrayList<ShapeView>();
		}
		// Implementation de l'interface d'iteration
		public Iterator<ShapeView> iterator(){
			return shapes.iterator();
		}
		
		public void addShape(ShapeView s){
			shapes.add(s);
			this.repaint();
		}
		
		public void paintComponent(Graphics g) {
			super.paintComponent(g);
			for(ShapeView s : shapes){
				s.paintComponent(g);
			}
		}
		
		//Réinitialise le Shape (cfr mise à jour)
		public void clear(){
			shapes.clear();
			this.repaint();
		}
		
		public ArrayList<ShapeView> getShapes() {
			return shapes;
		}
		
		public void setShapes(ArrayList<ShapeView> shapes) {
			this.shapes = shapes;
		}
		
		
	}
