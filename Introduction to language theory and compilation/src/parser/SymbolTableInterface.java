package parser;

public interface SymbolTableInterface {
	
	
	public void addFunction(Function f);
	
	public void addVariable(String name, char type);
	
	public char getVariableType(String name);
	
	public void print();
	
	public char getType(String name);
	
	public char getFunctionType(String fname);
	
	public char getArgType(String fname, int index);
	
	public int getArgsNumber(String fname);
}
