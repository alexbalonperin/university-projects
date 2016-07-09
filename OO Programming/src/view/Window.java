package view;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.util.ArrayList;

import javax.swing.JFrame;

import controler.BallMouseListenerSnooker;
import controler.QueueMouseListener;

//Cette classe est la fenetre principale de jeu.
//Elle contient donc tous les objets graphiques qui seront affiches a l'ecran.

public class Window extends JFrame{
	
	private static final long serialVersionUID = 1L;
	private Drawing drawing;
	private Dimension dimSnooker;
	private int nbHoles;
	private int nbBalls;
	private ArrayList<HoleView> holeViewList = new ArrayList<HoleView>();
	private ArrayList<BallView> ballViewList = new ArrayList<BallView>();
	private QueueView queueView;
	private TableView tableView;
	private CounterView counterView;
	private String names[];
	
	public Window(String titel, Dimension dimWindow, Dimension dimSnooker, QueueMouseListener queueControler, BallMouseListenerSnooker ballControler, int nbBalls, int nbHoles, String names[]) {
		this.setTitle(titel);
		this.setBackground(Color.white);
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		this.setSize(dimWindow);
		this.setLocationRelativeTo(null);

		this.nbBalls = nbBalls;
		this.nbHoles = nbHoles;
		this.dimSnooker = dimSnooker;
		this.names = names;
		
		drawing = new Drawing();
		drawing.setBackground(Color.GREEN.darker().darker());
		
		//ajout des listeners
		drawing.addMouseListener(queueControler);
		drawing.addMouseMotionListener(queueControler);
		drawing.addMouseListener(ballControler);
		drawing.addMouseMotionListener(ballControler);
			
		initializeViews();
		this.getContentPane().add(drawing, BorderLayout.CENTER);
		this.setVisible(true);
				
	}
	
	private void initializeViews()
	{
		// comptes joueurs
		Dimension dimPlayerCount = new Dimension(dimSnooker.width/2, 100);
		counterView = new CounterView(dimSnooker.height-25, dimPlayerCount, drawing, names);
		drawing.addShape(counterView);
		
		//table
		tableView = new TableView(dimSnooker, drawing);
		drawing.addShape(tableView);
		
		//trous
		for(int curHole = 0; curHole < nbHoles; curHole++)
		{	
			HoleView holeView = new HoleView(drawing);
			drawing.addShape(holeView);
			holeViewList.add(holeView);
		}
		
		//boules
		for (int curBall = 0; curBall < nbBalls; curBall++)
		{	
			BallView ballView = new BallView(drawing);
			drawing.addShape(ballView);
			ballViewList.add(ballView);
		}
		
		//queue
		queueView = new QueueView(drawing);
		drawing.addShape(queueView);
	}
	
	/*********************************************************************
	 * 				
	 * 								ACCESSEURS
	 * 
	 ********************************************************************** */
	
	public Drawing getDrawing() {
		return drawing;
	}

	public ArrayList<HoleView> getHoleViewList() {
		return holeViewList;
	}

	public ArrayList<BallView> getBallViewList() {
		return ballViewList;
	}

	public QueueView getQueueView() {
		return queueView;
	}

	public TableView getTableView() {
		return tableView;
	}

	public CounterView getCounterView() {
		return counterView;
	}

}
