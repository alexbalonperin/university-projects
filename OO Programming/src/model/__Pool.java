package model;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.geom.Point2D;
import java.awt.geom.Point2D.Double;
import java.util.ArrayList;

import javax.swing.BorderFactory;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JPanel;

//Cette classe est commune a tous les jeux de type billards.
//Elle implemente donc certaines fonctions de Game qui seront parfois redefinies en fonction du jeu precis (snooker ou billard).
//En particulier, elle gere un tour de billard mais sans tenir compte des regles. C'est-a-dire que s'il y a des regles specifiques contenant un tour, elles devront etre redefinies dans la sous-classe du jeu particulier.

public abstract class __Pool extends ___Game{
	
	protected Table table;
	protected Counter counter;
	protected Queue queue;
	
	protected BallsList fallenBalls = new BallsList();
	protected BallsList ballsList;
	protected HolesList holesList = new HolesList();
	protected BallsList lostBalls;
	protected ArrayList<Point2D.Double> posInit = new ArrayList<Point2D.Double>(); 

	protected int nbHoles;
	protected boolean inGame = false;
	protected boolean inRound = false;
	protected boolean WBinHole = false;
	
	//attributs de positionnement
	protected Dimension dimTable;
	protected int holesRadius;
	static int tableWidth; // On cree ces variables statiques car elles sont tres generale et pourront servir dans des classes tres eloignees.
	static int tableHeight;
	static double tablePosX;
	static double tablePosY;
	static int whiteLinePos = 200; //Meme si aucune ligne blanche n'est affichee sur un billard, sa position peut etre utile.
	

	@Override
	protected void initializeModel(String names[]) {
		this.playerList = new PlayerList(nbrPlayer, names);
		
		//table
		table = new Table(dimTable, holesList, new Point2D.Double(30,30));
		
		//attributs de positionnement
		tableWidth = table.getDimension().width;
		tableHeight = table.getDimension().height;
		tablePosX = table.getPosition().x;
		tablePosY = table.getPosition().y;
		
		//trous
		holesList.initializeHoles(nbHoles, holesRadius);
		//table.setHolesList(holesList);
		
		//compteur de points
		counter = new Counter(playerList, fallenBalls);
	}
	
	protected void initializeModel2()
	{	
		//queue
		queue = new Queue(ballsList.getBallsRadius());
		queue.setPosition(ballsList.getWhiteBall().getPosition());
		
		//Positions initiales des boules
		for (Ball c : ballsList)
			posInit.add((Double) c.getPosInit().clone());
	}
	

	protected void ballReplacement(){
		//ici on s'occupe seulement de replacer la BB
		for(Ball b : lostBalls)
		{
			if(b.getColor() == Color.white){
				Point2D.Double pos = (Double) b.getPosInit().clone();
				b.setPosition(pos);	
				WBinHole = true;
			}
		}
		try{
			Thread.sleep(100);
		}catch(InterruptedException e) {}
		
	}
	
	
	@Override
	//un tour de jeu
	void round(int player) {
		this.playerList.setCurPlayer(player);
				
		counter.notifyObserver();
		
		lostBalls = new BallsList();
		
		//tant que la blanche est a l'arret on ne fait rien
		while(!ballsList.getWhiteBall().isMoving())
			System.out.print("");	
		
		inRound = true;
		inGame = true;
		//demarrage du thread qui va gerer le deplacement des billes et leurs rebonds durant tout un tour
		RoundGestion t = new RoundGestion(this);
		t.run();
		
		nextPlayer = false;
		int changeScore = scoreMgmt(player);
		modifyScore(changeScore);
		
		inRound = false;
		ballReplacement();
	}
	
	abstract void modifyScore(int changeScore);
	abstract int scoreMgmt(int player); // calcule le score d'un tour
	
	@Override
	void winner() {
		//On trouve le gagnant
		int bestScore=0;
		Player winner = new Player("");
		for(Player p : playerList)
			if(p.getScore()>bestScore)
			{
				winner = p;
				bestScore = p.getScore();
			}
		
		//Gere l'affichage du gagnant
		Font font = new Font("Arial", Font.BOLD, 15);
		JDialog winnerDial = new JDialog(null, "Félicitation", JDialog.DEFAULT_MODALITY_TYPE);
		JPanel panel = new JPanel();
		panel.setBackground(Color.LIGHT_GRAY);
		panel.setPreferredSize(new Dimension(200,200));
		JLabel label = new JLabel("Le gagnant est :");
		label.setFont(font);
		panel.add(label);
		JLabel name = new JLabel(winner.getName());
		font = new Font("Arial", Font.BOLD, 30);
		name.setFont(font);
		name.setBorder(BorderFactory.createLineBorder(Color.RED));
		panel.add(name);
		winnerDial.setContentPane(panel);
		winnerDial.setSize(new Dimension(200,120));
		winnerDial.setLocationRelativeTo(null);
		winnerDial.setVisible(true);
	}
	
	@Override
	public boolean end() {
		// tester si la dernière boule de la liste est noir ou non
		if(ballsList.size()==1)
			return true;
		else
			return false;
	}

	/*********************************************************************
	 * 				
	 * 								ACCESSEURS
	 * 
	 ********************************************************************** */

	public Table getTable() {
		return table;
	}

	public Queue getQueue() {
		return queue;
	}

	public BallsList getBallsList() {
		return ballsList;
	}

	public HolesList getHolesList() {
		return holesList;
	}

	public BallsList getLostBalls() {
		return lostBalls;
	}

	public boolean isInGame() {
		return inGame;
	}

	public boolean isInRound() {
		return inRound;
	}

	public boolean isWBinHole() {
		return WBinHole;
	}

	public void setWBinHole(boolean wBinHole) {
		WBinHole = wBinHole;
	}
	
	public int getNbHoles() {
		return nbHoles;
	}

	public int getWhiteLinePos () {
		return whiteLinePos;
	}
	
	public Counter getCounter() {
		return counter;
	}

	
}