
public class InfoDialogInitPool {

	private String namePlayer1 = "Joueur 1", namePlayer2 = "Joueur 2";
	private int poolType;
	
	public InfoDialogInitPool(String namePlayer1, String namePlayer2, int poolType) {
		if(!namePlayer1.equals(""))
			this.namePlayer1 = namePlayer1;
		if(!namePlayer2.equals(""))
			this.namePlayer2 = namePlayer2;
		this.poolType = poolType;
	}

	public String getNamePlayer1() {
		return namePlayer1;
	}

	public void setNamePlayer1(String namePlayer1) {
		this.namePlayer1 = namePlayer1;
	}

	public String getNamePlayer2() {
		return namePlayer2;
	}

	public void setNamePlayer2(String namePlayer2) {
		this.namePlayer2 = namePlayer2;
	}

	public int getPoolType() {
		return poolType;
	}

	public void setPoolType(int poolType) {
		this.poolType = poolType;
	}

}
