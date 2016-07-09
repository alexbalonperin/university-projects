package view;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.Graphics;
import java.util.ArrayList;

import model.ObserverCounter;

//Cette classe graphique permet de dessiner le compteur de points a l'ecran.

public class CounterView extends ShapeView implements ObserverCounter {
	private Dimension dimension;
	boolean playerHasChange;
	private int height;
	private ArrayList<Integer> points = new ArrayList<Integer>();
	private ArrayList<Color> colorPlayer1 = new ArrayList<Color>();
	private ArrayList<Color> colorPlayer2 = new ArrayList<Color>();
	private int nbrPlayer = 2;
	private int playerTurn = 0; // Permet d'indiquer à qui c'est le tour de jouer.
	private String names[];

	public CounterView(int height, Dimension dimension, Drawing drawing, String names[]) {
		this.dimension = dimension;
		this.drawing = drawing;
		this.height = height;
		this.names = names;
		for (int i=0; i<nbrPlayer; i++)
		{
			points.add(0);
		}
	}
	
	@Override
	public void paintComponent(Graphics g) {
		g.setColor(Color.GREEN.darker().darker());
		// Cadres et gadgets
			// Cadres principaux
		g.fillRect(0, height, dimension.width, dimension.height);
		g.fillRect(dimension.width, height, dimension.width, dimension.height);
		g.setColor(Color.GREEN.darker());
		g.fillRoundRect(10+(dimension.width-5)*playerTurn, height+10, dimension.width-15, dimension.height-20, 10, 10);
		g.setColor(Color.LIGHT_GRAY);
		g.drawRoundRect(10, height+10, dimension.width-15, dimension.height-20, 10, 10);
		g.drawRoundRect(dimension.width+5, height+10, dimension.width-15, dimension.height-20, 10, 10);
			// Cadres entourants les noms des joueurs
		g.drawRoundRect(25, height+18, 105, 30, 5, 5);
		g.drawRoundRect(dimension.width+20, height+18, 105, 30, 5, 5);
			// Dessin d'une boule blanche pour indiquer à qui c'est le tour de jouer.
		g.setColor(Color.white);
		g.fillOval(150+playerTurn*dimension.width, height + 20, 25, 25);
		g.setColor(Color.LIGHT_GRAY);
		
		// Chaines de caractères
		Font font = new Font("Arial", Font.BOLD, 20);
		g.setFont(font);
		g.drawString(names[0],30, height+40);
		g.drawString(names[1], dimension.width+25, height+40);
		font = new Font("Arial", Font.BOLD, 30);
		g.setFont(font);
		g.drawString("Points :", 225, height+60);
		g.drawString("Points :", dimension.width+225, height+60);
		g.drawString(""+points.get(0), 425, height+60);
		g.drawString(""+points.get(1), dimension.width+425, height+60);
		
		// Dessins des boules déjà empochées durant le tour de jeu
		try{
			//if(playerTurn == 0)
				for(int i=0; i<colorPlayer1.size(); i++){
					g.setColor(colorPlayer1.get(i));
					g.fillOval((30*(i+1)), height+56, 25, 25);
				}
			//else
				for(int i=0; i<colorPlayer2.size(); i++){
					g.setColor(colorPlayer2.get(i));
					g.fillOval((30*(i+1))+dimension.width, height+56, 25, 25);
				}
		}catch(NullPointerException e){}
	}
	
	@Override
	public void update(int turn, ArrayList<Integer> points, ArrayList<Color> color){
		boolean playerHasChange = (turn!=this.playerTurn);
		if(playerHasChange){
			if(turn == 0)
				this.colorPlayer1.clear();
			else
				this.colorPlayer2.clear();
		}
		this.playerTurn = turn;
		this.points = points;
		if(turn == 0)
			this.colorPlayer1.addAll(color);
		else
			this.colorPlayer2.addAll(color);
		
		drawing.repaint();
	}
}
