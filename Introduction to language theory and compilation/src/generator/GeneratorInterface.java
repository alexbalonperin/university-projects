package generator;

public interface GeneratorInterface {
	public void jumpToMain();
	public void defineMain();
	public void stop();
	public void defineFunctionID(String tokenID);
	public void endOfScope (boolean typedFunction);
	public void defineID(int address, char type);
	public void read(int address, char type);
	public void print();
	public void returnValue(char type);
	public void pass();
	public void assignValue(int address, char type, boolean isGlobal);
	public void functionCall(boolean fromFunction, int nbArgs, String name);
	public void else_(boolean hasElse);
	public void afterIf();
	public void defineElse();
	public void while_();
	public void afterWhile();
	public void release();
	public void reset();
	public void or();
	public void and();
	public void grt();
	public void geq();
	public void less();
	public void leq();
	public void equal(char type);
	public void diff(char type);
	public void add();
	public void sub();
	public void mul();
	public void div();
	public void neg();
	public void not();
	public void INTEGER_LITERAL(String value);
	public void BOOLEAN_LITERAL(String value);
	public void getIDValue(int address,char type, boolean isGlobal);
	public void jumpAfterIf();
	public void endl();
	public void put();
	public void putr();
	public void hold();
	public void get();
	public void createStackFrame(boolean fromFunction);
	public void defineWhile();
	public void loopWhile();
}
