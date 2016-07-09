package view;

import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Image;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;

//Cette classe represente la partie graphique de la table.

public class TableView extends ShapeView{

	private Dimension dimension;
	
	
	// On crée la table graphique
	public TableView(Dimension dim, Drawing drawing) 
	{
		dimension = dim;
		this.drawing = drawing;
	}

	public Dimension getDimension() {
		return dimension;
	}

	@Override
	public void paintComponent(Graphics g) {
		//La table consiste en une image
		try {
			Image img = ImageIO.read(new File("Images/snooker.jpg"));
			//Pour une image de fond
			g.drawImage(img, 0, 0, dimension.width, dimension.height - 25,  drawing);
		} 
		catch (IOException e) {
		// TODO Auto-generated catch block
			e.printStackTrace();
		}
	
	}


}
