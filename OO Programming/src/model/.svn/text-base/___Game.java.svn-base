package model;

import java.awt.Dimension;

//Cette classe est commune à n'importe quel jeu. Ses fonctions seront implementees par heritage en fonction du jeu a implementer.
//Elle permet de gerer une partie de maniere la plus globale possible.

public abstract class ___Game {
	
	protected int nbrPlayer = 2;
	protected Dimension dimGame;
	protected boolean nextPlayer;// Permet de savoir a quel joueur c'est le tour de jouer.
	protected PlayerList playerList;

	abstract void initializeModel(String names[]); // Demarrage du jeu.
	abstract void round(int player); // Gere un tour de jeu.
	abstract boolean end(); // Drclanche la procrdure de fin du jeu.
	abstract void winner(); // Affiche un pop-up de fin de Jeu.
	abstract int scoreMgmt(int player); // calcule le score d'un tour
	
	public void play() {
		/* Boucle du jeu (chacun joue a son tour jusqu'a ce que la 
		   condition de fin de jeu soit atteinte.  */
		int player = 0;
	
		while (!end()) 
		{
			round(player);
			if(nextPlayer)
				player = (player + 1) % nbrPlayer;			
		}
		
		winner();
	}
	public Dimension getDimGame() {
		return dimGame;
	}
	
}