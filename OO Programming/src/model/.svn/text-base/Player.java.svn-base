package model;

import java.awt.Color;

//Cette classe contient les principales caracteristiques d'un joueur.
//En particulier, elle contient son score, son nom et la couleur de la derniere boule qu'il a touchee (utile dans tous les jeux de billard).

public class Player {

	private int score = 0;
	private Color lastColorTouched = null; // les couleurs touchees en premier lors de plusieurs coups successifs
	private String name;
	
	public Player(String name) {
		this.name = name;
	}
	
	public void modifieScore(int score){
		this.score += score;
	}
	
	/*********************************************************************
	 * 				
	 * 								ACCESSEURS
	 * 
	 ********************************************************************** */

	public int getScore() {
		return score;
	}

	public void setScore(int score) {
		this.score = score;
	}

	public Color getLastColorTouched() {
		return lastColorTouched;
	}


	public void setLastColorTouched(Color lastColorTouched) {
		this.lastColorTouched = lastColorTouched;
	}

	public String getName() {
		return name;
	}
}
