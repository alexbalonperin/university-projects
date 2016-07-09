package model;

import java.util.ArrayList;

//Cette classe permet de particulariser la liste de joueurs.
//Cela signifie qu'elle ajoute des fonctionnalites qui permettent de gerer une liste de joueurs d'un jeu de billard.
//En particulier, elle va initialiser les joueurs et connait en permanence le numero du joueur qui est en train de joueur (curPlayer).


public class PlayerList extends ArrayList<Player> {

	private static final long serialVersionUID = 1L;
		
	private int curPlayer = 0;

	public PlayerList (int nbrPlayer, String names[])
	{
		for (int i=0; i<nbrPlayer; i++)
		{
			Player player = new Player(names[i]);
			this.add(player);
		}
			
	}
	
	/*********************************************************************
	 * 				
	 * 								ACCESSEURS
	 * 
	 ********************************************************************** */
	
	public void setCurPlayer(int curPlayer) {
		this.curPlayer = curPlayer;
	}

	public int getCurPlayer() {
		return curPlayer;
	}
	
}
