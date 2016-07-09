package scanner;


public interface DFAInterface {
	public void scan();
	public int getNumberOfTokens();
	public String getCorrespondingValue();
	public int getTokenAndGoToNext();
	public int getToken();
	public String getPreviousValue();
}
